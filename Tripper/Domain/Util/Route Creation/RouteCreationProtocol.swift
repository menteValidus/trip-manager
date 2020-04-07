//
//  RouteCreationProtocol.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreLocation
import MapboxDirections

typealias CoordinatesDictionary = Dictionary<String, CLLocationCoordinate2D>

protocol RouteCreator {
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (Route?) -> Void)
}
