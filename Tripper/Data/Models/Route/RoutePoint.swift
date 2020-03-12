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
    
    // Nullable in case it's the start of trip.
    var arrivalDate: Date?
    // Nullable in case it's the end of trip.
    var departureDate: Date?
    
    var residenceTimeInSeconds: Int? {
        if let departureDate = departureDate, let arrivalDate = arrivalDate {
            return Int(departureDate.timeIntervalSince(arrivalDate))
        } else {
            return nil
        }
    }
    
    var residenceTimeInMinutes: Int? {
        if let time = residenceTimeInSeconds {
            return time / 60
        } else {
            return nil
        }
    }
    
    var timeToNextPointInMinutes: Int? {
        get {
            if let time = timeToNextPointInSeconds {
                return time / 60
            } else {
                return nil
            }
        }
        set {
            if let time = newValue {
                timeToNextPointInSeconds = time * 60
            } else {
                timeToNextPointInSeconds = newValue
            }
        }
    }
    
    // Nullable in case it's the end of trip.
    var timeToNextPointInSeconds: Int?
    // Nullable in case it's the start of trip.
    var distanceToNextPointInMeters: Int?
    
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
