//
//  RouteController.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

class RouteController {
    var routeControllerDelegate: RouteControllerDelegate
    
    private let routePointGateway = CoreDataRoutePointDAO()
    private let routeCreator: MapBoxRouteCreator

    private(set) var points: [RoutePoint]
    private var remainingRouteSegmentsToCalculate = 0
    
    var isProperForRouteCreation: Bool {
        return points.count > 1
    }
    
    private var isNotCalculating: Bool {
        return remainingRouteSegmentsToCalculate == 0
    }
    
    var totalLengthInMeters: Int {
        var length = 0
        for point in points {
            length += point.distanceToNextPointInMeters ?? 0
        }
        return length
    }
    
    var totalTimeInMinutes: Int {
        var minutes = 0
        
        for point in points {
            minutes += point.residenceTimeInMinutes ?? 0
            minutes += point.timeToNextPointInMinutes ?? 0
        }
        
        return minutes
    }
    
    var subroutes: [Subroute] {
        switch countSubroutes {
        case 0:
            return []
        case 1:
            let routePoint = points[0]
            let stayingPoint = Staying(title: routePoint.title ?? "Staying #1", seconds: routePoint.timeToNextPointInSeconds ?? 0)
            return [stayingPoint]
        default:
            var subroutes = [Subroute]()
            for subrouteIndex in 0..<countSubroutes {
                subroutes.append(getSubroute(at: subrouteIndex))
            }
            return subroutes
        }
    }
    
    private var nextRoutePointNumber: Int {
        return points.count + 1
    }
    
    // Subroute means any division of main route. i.e. Stop in city for 2 days, road between points for 3 hours, etc.
    var countSubroutes: Int {
        switch points.count {
        case 0:
            return 0
        case 1:
            return 1
        default:
            // This formula calculate overall number of route points and roads.
            return points.count * 2 - 1
        }
    }
    
    init(delegate routeControllerDelegate: RouteControllerDelegate) {
        self.routeControllerDelegate = routeControllerDelegate
        
        let fetchedPoints = routePointGateway.fetchAll()
        points = fetchedPoints.sorted(by: { el1, el2 in
            if (el1.orderNumber < el2.orderNumber) {
                return true
            } else {
                return false
            }
        })
        
        var coordinatesDictionary: CoordinatesDictionary = Dictionary()
        for point in points {
            coordinatesDictionary[point.id] = point.coordinate
        }
        
        routeCreator = MapBoxRouteCreator(coordinates: coordinatesDictionary)
        
        recreateRoute()
    }
    
    // MARK: - DB Communication Methods
    
    func add(point: RoutePoint) {
        points.append(point)
        routePointGateway.insert(point)
    }
    
    func update(routePoint: RoutePoint) {
        for index in 0..<points.count {
            if points[index].id == routePoint.id {
                points[index] = routePoint
                break
            }
        }
        
        routePointGateway.update(routePoint)
    }
    
    func delete(routePoint: RoutePoint) {
        var indexOfDeletingRoutePoint: Int? = nil
        
        for (index, point) in points.enumerated() {
            if point.id == routePoint.id {
                indexOfDeletingRoutePoint = index
                handleRouteFixing(withRemovingRPAt: indexOfDeletingRoutePoint!)
                break
            }
        }
        
        routePointGateway.delete(routePoint)
    }
    
    func deleteAll() {
        points.removeAll()
        routePointGateway.deleteAll()
        
        routeControllerDelegate.routeControllerCleared()
    }
    
    // MARK: - Route mapping
    
    private func recreateRoute() {
        guard isProperForRouteCreation else { return }
        
        for index in 0..<(points.count - 1) {
            createRouteFragment(from: points[index], to: points[index + 1])
        }
    }
    
    /**
     Arguments of completion handler are:
     1. Expected time to get to next route point.
     2. Distance between two route points.
     */
    private func createRouteFragment(from source: RoutePoint, to destination: RoutePoint) {
        remainingRouteSegmentsToCalculate += 1
        routeControllerDelegate.routeControllerIsStartedRouting()
        
        routeCreator.calculateRoute(from: source.coordinate, to: destination.coordinate, drawHandler: { route in
            if let route = route, let shape = route.shape {
                let routeFragmentId = source.id + destination.id
                let createdRouteFragment = RouteFragment(identifier: routeFragmentId, coordinates: shape.coordinates, timeInSeconds: Int(route.expectedTravelTime), distanceInMeters: Int(route.distance))
                
                self.routeControllerDelegate.routeController(didCalculated: createdRouteFragment)
                self.remainingRouteSegmentsToCalculate -= 1
                
                if self.isNotCalculating {
                    self.routeControllerDelegate.routeControllerIsFinishedRouting()
                }
            }
        })
    }
    
    private func handleRouteFixing(withRemovingRPAt index: Int) {
        guard isProperForRouteCreation else {
            points.remove(at: index)
            return
        }
        
        switch index {
        case 0: // First point
            let identifier = points[index].id + points[index + 1].id
            routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
            
        case points.count - 1: // Last point
            let identifier = points[index - 1].id + points[index].id
            routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
            
        default: // Other points in middle of route.
            let indexOfPreviousRP = index - 1
            var identifier = points[indexOfPreviousRP].id + points[index].id
            routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
            
            let indexOfNextRP = index + 1
            identifier = points[index].id + points[indexOfNextRP].id
            routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
            
            createRouteFragment(from: points[indexOfPreviousRP], to: points[indexOfNextRP])
            
        }
        
        points.remove(at: index)
    }
    
    // MARK: - Helper Methods
    
    func findRoutePointBy(id: String) -> RoutePoint? {
        return points.first(where: { routePoint in
            return routePoint.id == id
        })
    }
    
    func getIndex(of routePoint: RoutePoint) -> Int? {
        for (index, point) in points.enumerated() {
            if routePoint.id == point.id {
                return index
            }
        }
        
        return nil
    }
    
    func getSubroute(at index: Int) -> Subroute {
        // We divide index by 2 to conform index of route point in points array.
        let i = index / 2
        let point = points[i]
        
        if index % 2 == 0 {
            return Staying(title: point.title ?? "Staying #\(i)", minutes: point.residenceTimeInMinutes ?? 0)
        } else {
            return InRoad(minutes: point.timeToNextPointInMinutes ?? 0, metres: point.distanceToNextPointInMeters ?? 0)
        }
    }
    
    func createNextRoutePoint(at coordinate: CLLocationCoordinate2D) -> RoutePoint {
        let point = RoutePoint()
        point.coordinate = coordinate
        point.title = "Route point #\(nextRoutePointNumber)"
        add(point: point)
        
        if isProperForRouteCreation {
            let indexOfCreatedPoint = points.count - 1
            createRouteFragment(from: points[indexOfCreatedPoint - 1], to: points[indexOfCreatedPoint])
        }
        
        return point
    }
    
    func isNotEmpty() -> Bool {
        return points.count != 0
    }
    
}
