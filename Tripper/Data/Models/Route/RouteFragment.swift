//
//  RouteFragment.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

class RouteFragment {
    var identifier: String
    var coordinates: [CLLocationCoordinate2D]
    var travelTimeInSeconds: Int
    var travelDistanceInMeters: Int
    
    init(identifier: String, coordinates: [CLLocationCoordinate2D], timeInSeconds: Int, distanceInMeters: Int) {
        self.identifier = identifier
        self.coordinates = coordinates
        travelTimeInSeconds = timeInSeconds
        travelDistanceInMeters = distanceInMeters
    }
}
