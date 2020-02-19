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
    var latitude: Double = 0
    var longitude: Double = 0
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
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    init() {
        id = idGenerator.uuidString
        latitude = 0
        longitude = 0
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
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(id: String, longitude: Double, latitude: Double, title: String, subtitle: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}
