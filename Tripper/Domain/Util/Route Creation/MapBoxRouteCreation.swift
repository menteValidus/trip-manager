//
//  MapBoxRouteCreation.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation
import MapboxCoreNavigation
import MapboxDirections

class MapBoxRouteCreatorVM {
    
    // Helper Methods
    
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (Route?) -> Void) {
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let sourceWaypoint = Waypoint(coordinate: source, coordinateAccuracy: -1, name: "Start")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [sourceWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        Directions.shared.calculate(options, completionHandler: { (_, routes, error) in
            drawHandler(routes?.first)
        })
    }
    
}
