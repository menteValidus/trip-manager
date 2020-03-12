//
//  MapBoxRouteCreation.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class MapBoxRouteCreation {
    typealias CoordinatesDictionary = Dictionary<String, CLLocationCoordinate2D>
    
    private var coordinates: CoordinatesDictionary = Dictionary()
    
    init(coordinates: CoordinatesDictionary) {
        self.coordinates = coordinates
    }
    
    
}
