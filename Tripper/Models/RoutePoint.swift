//
//  Annotation.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

protocol AnnotationInfo {
    var id: String { get }
    var orderNumber: Int { get }
    var latitude: Double { get }
    var longitude: Double { get }
}

struct RoutePoint: AnnotationInfo {
    let id: String
    
    var orderNumber: Int
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    var arrivalDate: Date
    var departureDate: Date
}

func ==(lhs: RoutePoint, rhs: RoutePoint) -> Bool
{
    return lhs.id == rhs.id
}
