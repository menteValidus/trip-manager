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

protocol AnnotationForm {
    var title: String { get set }
    var subtitle: String { get set }
    
    var arrivalDate: Date { get set }
    var departureDate: Date { get set }
    
    var timeToNextPointInSeconds: Int? { get set }
    var distanceToNextPointInMeters: Int? { get set }
}

struct RoutePoint: AnnotationInfo, AnnotationForm {
    let id: String
    
    var orderNumber: Int
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    var arrivalDate: Date
    var departureDate: Date
    
    // Nullable in case it's the end of trip.
    var timeToNextPointInSeconds: Int?
    // Nullable in case it's the start of trip.
    var distanceToNextPointInMeters: Int?
}

func ==(lhs: RoutePoint, rhs: RoutePoint) -> Bool
{
    return lhs.id == rhs.id
}
