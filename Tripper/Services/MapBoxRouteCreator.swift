//
//  MBRouteCreator.swift
//  Tripper
//
//  Created by Denis Cherniy on 14.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreLocation
import MapboxDirections
import MapboxCoreNavigation

protocol RouteCreator: class {
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (RouteInfo?) -> Void)
}

struct RouteInfo {
    let coordinates: [CLLocationCoordinate2D]
    let timeInSeconds: Int
    let distanceInMeters: Int
}

fileprivate struct FragmentInfo: Equatable {
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    
    let routeInfo: RouteInfo
    
    static func == (lhs: FragmentInfo, rhs: FragmentInfo) -> Bool {
        if lhs.start == rhs.start && lhs.end == rhs.end {
            return true
        }
        
        return false
    }
}

class MapboxRouteCreator: RouteCreator {
    private var fragmentsInfoTemporalCache: [FragmentInfo]
    
    init() {
        fragmentsInfoTemporalCache = []
    }
    
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (RouteInfo?) -> Void) {
        if let cachedRouteInfo = lookForCachedInfo(start: source, end: destination) {
            drawHandler(cachedRouteInfo)
            return
        }
        
        let sourceWaypoint = Waypoint(coordinate: source, coordinateAccuracy: -1, name: "Start")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [sourceWaypoint, destinationWaypoint], profileIdentifier: .automobile)
        Directions.shared.calculate(options, completionHandler: { (_, routes, error) in
            guard error == nil else {
                drawHandler(nil)
                return
            }
            
            if let route = routes?.first, let routeCoordinates = route.coordinates {
                let coordinates = routeCoordinates
                let timeInSeconds = Int(route.expectedTravelTime)
                let distanceInMeters = Int(route.distance)
                let routeInfo = RouteInfo(coordinates: coordinates, timeInSeconds: timeInSeconds, distanceInMeters: distanceInMeters)
                
                let fragmentInfoToCache = FragmentInfo(start: source, end: destination, routeInfo: routeInfo)
                self.cache(fragmentInfo: fragmentInfoToCache)
                
                drawHandler(routeInfo)
            }
                
        })
    }
    
    // MARK: Caching
    
    private func lookForCachedInfo(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> RouteInfo? {
        let indexOfCachedObject = fragmentsInfoTemporalCache.firstIndex(where: { fragmentInfo in
            if fragmentInfo.start == start && fragmentInfo.end == end {
                return true
            }
            
            return false
        })
        
        if let index = indexOfCachedObject {
            let cachedRouteInfo = fragmentsInfoTemporalCache[index].routeInfo
            return cachedRouteInfo
        } else {
            return nil
        }
        
    }
    
    private func cache(fragmentInfo: FragmentInfo) {
        // Only 10 objects can be stored at the same time.
        if fragmentsInfoTemporalCache.count == 10 {
            fragmentsInfoTemporalCache.remove(at: 0)
        }
        
        fragmentsInfoTemporalCache.append(fragmentInfo)
    }
}
