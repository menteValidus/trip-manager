//
//  RouteDataModel.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

class RouteDataModel {
    private let routePointGateway = CoreDataRoutePointDAO()

    private(set) var points: [RoutePoint]
//    var inRoadList: [InRoad] = []
    
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
        
//    private var _subroutes: [Subroute]?
//    var subroutes: [Subroute] {
//        guard let subroutes = _subroutes else {
//            if points.isEmpty {
//                _subroutes = []
//                return _subroutes!
//            } else {
//                _subroutes = [Subroute]()
//                let firstPoint = points[0]
//                var residenceTimeInSeconds = 0
//                if let arrivalDate = firstPoint.arrivalDate, let departureDate = firstPoint.departureDate {
//                    residenceTimeInSeconds = Int(arrivalDate.timeIntervalSince(departureDate))
//                }
//
//                _subroutes!.append(Staying(title: firstPoint.title ?? "Staying #1", minutes: residenceTimeInSeconds))
//                for index in 1..<points.count {
//                    _subroutes!.append(inRoadList[index - 1])
//
//                    let point = points[index]
//                    var residenceTimeInSeconds = 0
//                    if let arrivalDate = point.arrivalDate, let departureDate = point.departureDate {
//                        residenceTimeInSeconds = Int(arrivalDate.timeIntervalSince(departureDate))
//                    }
//                    _subroutes!.append(Staying(title: point.title ?? "Staying #\(index + 1)", minutes: residenceTimeInSeconds))
//                }
//
//                return _subroutes!
//            }
//
//
//        }
//
//        return subroutes
//    }
    
    
    
    private var nextRoutePointNumber: Int {
        return points.count + 1
    }
    
    // Subroute means any division of main route. i.e. Stop in city for 2 days, road between points for 3 hours, etc.
//    var countSubroutes: Int {
//        if points.count > 0 {
//            // This formula calculate overall number of route points and roads.
//            return points.count * 2 - 1
//        } else {
//            return 0
//        }
//    }
    
    init() {
        points = routePointGateway.fetchAll()
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
        for (index, point) in points.enumerated() {
            if point.id == routePoint.id {
                points.remove(at: index)
                break
            }
        }
        
        routePointGateway.delete(routePoint)
    }
    
    func deleteAll() {
        points.removeAll()
        routePointGateway.deleteAll()
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
    
    func createRoutePointWithoutAppending() -> RoutePoint {
        let point = RoutePoint()
        point.title = "Route point #\(nextRoutePointNumber)"
        return point
    }
    
    func isNotEmpty() -> Bool {
        return points.count != 0
    }
    
    func isProperForRouteCreation() -> Bool {
        return points.count > 1
    }
    
}
