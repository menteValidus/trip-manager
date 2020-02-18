//
//  RoutePointAnnotation.swift
//  Tripper
//
//  Created by Denis Cherniy on 14.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import MapKit

class RoutePointAnnotation: MKPointAnnotation {
    var id: String
    
    init(id: String) {
        self.id = id
        
        super.init()
    }
}
