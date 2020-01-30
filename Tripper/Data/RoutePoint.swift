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
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: coordinate)
    }
    var mapItem: MKMapItem {
        return MKMapItem(placemark: placemark)
    }
    
    var longitude: Double {
        return coordinate.longitude
    }
    
    var latitude: Double {
        return coordinate.latitude
    }
    
    init(from annotation: MKAnnotation) {
        coordinate = annotation.coordinate
        title = annotation.title ?? ""
        subtitle = annotation.subtitle ?? ""
    }
}
