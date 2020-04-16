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

class MapboxRouteCreator: RouteCreator {
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (RouteInfo?) -> Void) {
        
        let sourceWaypoint = Waypoint(coordinate: source, coordinateAccuracy: -1, name: "Start")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [sourceWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
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
        
                drawHandler(routeInfo)
            }
                
        })
    }
    
    
}
