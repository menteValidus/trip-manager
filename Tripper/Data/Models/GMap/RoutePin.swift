//
//  RoutePin.swift
//  Tripper
//
//  Created by Denis Cherniy on 19.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import GoogleMaps

class RoutePin: GMSMarker {
    let id: String
    
    init(routeID: String, position: CLLocationCoordinate2D) {
        self.id = routeID
    
        super.init()
        self.position = position
    }
}
