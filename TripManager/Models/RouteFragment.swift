//
//  RouteFragment.swift
//  Tripper
//
//  Created by Denis Cherniy on 29.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreLocation

protocol RouteFragment {
    var identifier: String { get }
    var startPointID: String { get set }
    var endPointID: String { get set }
    var coordinates: [CLLocationCoordinate2D] { get set }
    var travelTimeInSeconds: Int { get set }
    var travelDistanceInMeters: Int { get set }
    var isFinished: Bool { get set }
}

struct ConcreteRouteFragment: RouteFragment {
    var startPointID: String
    var endPointID: String
    var coordinates: [CLLocationCoordinate2D]
    var travelTimeInSeconds: Int
    var travelDistanceInMeters: Int
    var isFinished: Bool
    
    var identifier: String {
        let id = format(firstID: startPointID, secondID: endPointID)
        return id
    }
}
