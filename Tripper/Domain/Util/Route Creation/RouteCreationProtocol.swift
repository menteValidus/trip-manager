//
//  RouteCreationProtocol.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreLocation

typealias CoordinatesDictionary = Dictionary<String, CLLocationCoordinate2D>

protocol RouteCreator {
    func add(routeCoordinate: CLLocationCoordinate2D, with id: String)
    func remove(coordinateWith id: String)
    func calculate()
}
