//
//  Annotation.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import MapKit

class RoutePoint {
    let id: String
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    // Nullable in case it's the end of trip.
    var timeToGetToNextPointInMinutes: Int? = 60
    // Nullable in case it's the start of trip.
    var residenceTimeInMinutes: Int? = 120
    
    let idGenerator = NSUUID()
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: coordinate)
    }
    
    var mapItem: MKMapItem {
        return MKMapItem(placemark: placemark)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(from annotation: MKAnnotation) {
        id = idGenerator.uuidString
        latitude = annotation.coordinate.latitude
        longitude = annotation.coordinate.longitude
        title = annotation.title ?? ""
        subtitle = annotation.subtitle ?? ""
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String = "", subtitle: String = "") {
        id = idGenerator.uuidString
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        self.title = title
        self.subtitle = subtitle
    }
    
    init(id: String, longitude: Double, latitude: Double, title: String, subtitle: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}
