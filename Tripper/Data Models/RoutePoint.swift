//
//  Annotation.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import MapKit

class RoutePoint: Codable {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
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
        latitude = annotation.coordinate.latitude
        longitude = annotation.coordinate.longitude
        title = annotation.title ?? ""
        subtitle = annotation.subtitle ?? ""
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String = "", subtitle: String = "") {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
