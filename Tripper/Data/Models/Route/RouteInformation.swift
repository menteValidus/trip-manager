//
//  RouteInformation.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

class RouteInformation {
    var coordinates: [CLLocationCoordinate2D]
    var travelTimeInSeconds: Int
    var travelDistanceInMeters: Int
    
    init() {
        coordinates = []
        travelTimeInSeconds = 0
        travelDistanceInMeters = 0
    }
    
    init(coordinates: [CLLocationCoordinate2D], timeInSeconds: Int, distanceInMeters: Int) {
        self.coordinates = coordinates
        travelTimeInSeconds = timeInSeconds
        travelDistanceInMeters = distanceInMeters
    }
}
