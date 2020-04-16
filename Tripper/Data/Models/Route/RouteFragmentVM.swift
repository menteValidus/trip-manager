//
//  RouteFragment.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

protocol RouteFragment {
    var identifier: String { get set }
    var coordinates: [CLLocationCoordinate2D] { get set }
    var travelTimeInSeconds: Int { get set }
    var travelDistanceInMeters: Int { get set }
}

struct RouteFragmentVM: RouteFragment {
    var identifier: String
    var coordinates: [CLLocationCoordinate2D]
    var travelTimeInSeconds: Int
    var travelDistanceInMeters: Int
}
