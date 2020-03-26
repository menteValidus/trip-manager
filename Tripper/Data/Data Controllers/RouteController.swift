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
    
    var totalTimeInSeconds: Int {
        return totalTimeInMinutes * TimeUnits.minute
    }
    
    var subroutes: [Subroute] {
        switch countSubroutes {
        case 0:
            return []
        case 1:
            let routePoint = points[0]
            let stayingPoint = Staying.Factory.create(from: routePoint)
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
    
    private func add(point: RoutePoint) {
        points.append(point)
        routePointGateway.insert(point)
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
        routeControllerDelegate.routeController(didDeleted: routePoint)
    }
    
    func deleteAll() {
        points.removeAll()
        routePointGateway.deleteAll()
        
        routeControllerDelegate.routeControllerCleared()
    }
    
    func update(routePoint: RoutePoint) {
        for index in 0..<points.count {
            if points[index].id == routePoint.id {
                
                updateWholeRouteDates(with: routePoint, at: index)
                break
            }
        }
        
        routePointGateway.update(routePoint)
        routeControllerDelegate.routeControllerDidUpdated()
    }
    
    private func updateWholeRouteDates(with routePoint: RoutePoint, at index: Int) {
        if isProperForRouteCreation {
            switch index {
            case points.count - 1: // Last item.
                updateDateBefore(index: index, with: routePoint)
                
            case 0: // First item.
                updateDateAfter(index: index, with: routePoint)
                
            default:
                updateDateAfter(index: index, with: routePoint)
                updateDateBefore(index: index, with: routePoint)
                
            }
            
        }
    }
    
    // MARK: Update's Helper Methods

    /**
     Doesn't handle cases when accesed beyound the bounds of list.
     */
    private func updateDateAfter(index: Int, with newRoutePoint: RoutePoint) {
        let oldValueOfRP = points[index]
        
        if oldValueOfRP.departureDate != newRoutePoint.departureDate {
            let nextRP = points[index + 1]
            if let arrivalDateOfNextRP = nextRP.arrivalDate {
                let timeInterval = arrivalDateOfNextRP.timeIntervalSince(newRoutePoint.departureDate!)
                newRoutePoint.timeToNextPointInSeconds = Int(timeInterval)
            }else {
                throwAn(errorMessage: "RouteController.updateWholeRouteDates: When the second point exists it should alreade have initialized arrivalDate.")
            }
        }
        
        points[index] = newRoutePoint
    }
    
    /**
    Doesn't handle cases when accesed beyound the bounds of list.
    */
    private func updateDateBefore(index: Int, with newRoutePoint: RoutePoint) {
        let oldValueOfRP = points[index]
        
        if (oldValueOfRP.arrivalDate != newRoutePoint.arrivalDate) {
            let previousRP = points[index - 1]
            if let departureDateOfPreviousRP = previousRP.departureDate { // By this point all dates should be already initialized.
                let timeInterval = newRoutePoint.arrivalDate!.timeIntervalSince(departureDateOfPreviousRP)
                previousRP.timeToNextPointInSeconds = Int(timeInterval)
            } else {
                throwAn(errorMessage: "RouteController.updateWholeRouteDates: When the second point exists first point should alreade have initialized departureDate.")
            }
        }
        
        points[index] = newRoutePoint
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
            if let route = route {
                let routeFragmentId = source.id + destination.id
                source.timeToNextPointInSeconds = Int(route.expectedTravelTime)
                source.distanceToNextPointInMeters = Int(route.distance)
                
                let createdRouteFragment = RouteFragment(identifier: routeFragmentId, coordinates: route.coordinates!, timeInSeconds: source.timeToNextPointInSeconds!, distanceInMeters: source.distanceToNextPointInMeters!)
                
                self.configureDates(for: destination, with: source, using: route.expectedTravelTime)
                
                self.routeControllerDelegate.routeController(didCalculated: createdRouteFragment)
                self.remainingRouteSegmentsToCalculate -= 1
                
                if self.isNotCalculating {
                    self.routeControllerDelegate.routeControllerIsFinishedRouting()
                }
            } else {
                self.routeControllerDelegate.routeControllerError(with: destination)
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
            handleRouteFixing(after: index)
            
        case points.count - 1: // Last point
            handleRouteFixing(before: index)
            
        default: // Other points in middle of route.
            handleRouteFixing(after: index)
            handleRouteFixing(before: index)
            
            let previousRoutePoint = points[index - 1]
            let nextRoutePoint = points[index + 1]
            
            createRouteFragment(from: previousRoutePoint, to: nextRoutePoint)
        }
        
        // We are deleting point in the of method because logic of handling methods is linked to the existing points list.
        points.remove(at: index)
    }
    
    /**
     This method does'nt delete point at routePointIndex.
     Tells delegate identifier of RoutePoint which is going to be deleted.
     Doesn't handle reaching out of the list.
     */
    private func handleRouteFixing(after routePointIndex: Int) {
        let routePoint = points[routePointIndex]
        let nextRoutePoint = points[routePointIndex + 1]
        let identifier = routePoint.id + nextRoutePoint.id
        routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
    }
    
    /**
     This method does'nt delete point at routePointIndex.
     Tells delegate identifier of RoutePoint which is going to be deleted.
     Doesn't handle reaching out of the list.
     Clears previous RoutePoint's timeToNextPoint and distanceToNextPoint.
     */
    private func handleRouteFixing(before routePointIndex: Int) {
        let routePoint = points[routePointIndex]
        let previousRoutePoint = points[routePointIndex - 1]
        let identifier = previousRoutePoint.id + routePoint.id
        
        previousRoutePoint.timeToNextPointInSeconds = nil
        previousRoutePoint.distanceToNextPointInMeters = nil
        
        routeControllerDelegate.routeController(identifierOfDeletedRouteFragment: identifier)
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
            return Staying.Factory.create(from: point)
        } else {            
            return InRoad.Factory.create(from: point)
        }
    }
    
    func createNextRoutePoint(at coordinate: CLLocationCoordinate2D) -> RoutePoint {
        let newRoutePoint = getNextRoutePointInstance()
        newRoutePoint.coordinate = coordinate
        setNextRoutePoint(routePoint: newRoutePoint)
        return newRoutePoint
    }
    
    private func getNextRoutePointInstance() -> RoutePoint {
        let newRoutePoint = RoutePoint()
        newRoutePoint.title = "Route point #\(nextRoutePointNumber)"
        return newRoutePoint
    }
    
    private func setNextRoutePoint(routePoint: RoutePoint) {
        add(point: routePoint)
        
        if isProperForRouteCreation {
            let indexOfCreatedPoint = points.count - 1
            createRouteFragment(from: points[indexOfCreatedPoint - 1], to: points[indexOfCreatedPoint])
        } else {
            
        }
    }
    
    func leftLimitOf(_ routePoint: RoutePoint) -> Date? {
        let index = getIndex(of: routePoint)
        
        if let index = index {
            if isProperForRouteCreation {
                if index != 0 {
                    return points[index - 1].departureDate
                }
            }
        }
        
        return nil
    }
    
    func rightLimitOf(_ routePoint: RoutePoint) -> Date? {
        let index = getIndex(of: routePoint)
        
        if let index = index {
            if isProperForRouteCreation {
                if index != points.count - 1 {
                    return points[index + 1].arrivalDate
                }
            }
        }
        
        return nil
    }
    
    private func configureDates(for routePoint: RoutePoint, with sourceRoutePoint: RoutePoint, using routeTimeLength: TimeInterval) {
        if let sourceDepartureDate = sourceRoutePoint.departureDate {
            routePoint.arrivalDate = sourceDepartureDate.addingTimeInterval(routeTimeLength)
        } else {
            if let sourceArrivalDate = sourceRoutePoint.arrivalDate {
                // Now this branch never accessed. Because arrivalDate and departureDate are both nil until they simultaneously
                // get their defaults. But in future logic of date assigning can be changed.
                sourceRoutePoint.departureDate = sourceArrivalDate
            } else {
                sourceRoutePoint.arrivalDate = Date()
                sourceRoutePoint.departureDate = Date()
            }
            
            routePoint.arrivalDate = sourceRoutePoint.departureDate!.addingTimeInterval(routeTimeLength)
        }
    }
    
}
