//
//  Annotation.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

class RoutePoint {
    let id: String
    var orderNumber: Int
    
    var title: String?
    var subtitle: String?
    var latitude: Double = 0
    var longitude: Double = 0
    
    var arrivalDate: Date?
    var departureDate: Date?
    
    // Nullable in case it's the end of trip.
    var timeToGetToNextPointInMinutes: Int? = 60
    // Nullable in case it's the start of trip.
    var residenceTimeInMinutes: Int? = 120
    
    private let idGenerator = NSUUID()
    
    struct UserDefaultsKeys {
        static let lastAssignedOrderNumber = "lastOrderNumber"
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
        self.id = idGenerator.uuidString
        let orderNumber = UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastAssignedOrderNumber) + 1
        self.orderNumber = orderNumber
        UserDefaults.standard.set(orderNumber, forKey: UserDefaultsKeys.lastAssignedOrderNumber)
        
        self.latitude = 0
        self.longitude = 0
    }
    
    init(id: String, orderNumber: Int, longitude: Double, latitude: Double, title: String, subtitle: String) {
        self.id = id
        self.orderNumber = orderNumber
        
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}
