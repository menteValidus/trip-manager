//
//  MKAnnotation+Equatable.swift
//  Tripper
//
//  Created by Denis Cherniy on 11.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import MapKit

extension MKAnnotation where Self: Equatable {
    // In the application there are no way to add two or more annotations to ecactly same place.
    static func ==(lhs: MKAnnotation, hrs: MKAnnotation) -> Bool {
        if lhs.coordinate.latitude == hrs.coordinate.latitude &&
        lhs.coordinate.longitude == hrs.coordinate.longitude {
            return true
        } else {
            return false
        }
    }
}
