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
    
    // Nullable in case it's the start of trip.
    var arrivalDate: Date
    // Nullable in case it's the end of trip.
    var departureDate: Date
    
    // Nullable in case it's the end of trip.
    var timeToNextPointInSeconds: Int?
    // Nullable in case it's the start of trip.
    var distanceToNextPointInMeters: Int?
}

class RoutePointVM {
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
    
    // Nullable in case it's the end of trip.
    var timeToNextPointInSeconds: Int?
    // Nullable in case it's the start of trip.
    var distanceToNextPointInMeters: Int?
    
    private let idGenerator = NSUUID()
    
    struct Factory {
        static func createNew(with id: String) -> RoutePointVM {
            let orderNumber = nextOrderNumber
            let newRoutePoint = RoutePointVM(id: id, orderNumber: orderNumber, longitude: 0, latitude: 0, title: "", subtitle: "")
            newRoutePoint.title = "Route Point #\(orderNumber)"
            return newRoutePoint
        }
    }
    
    static var nextOrderNumber: Int {
        let orderNumber = UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastAssignedOrderNumber) + 1
        UserDefaults.standard.set(orderNumber, forKey: UserDefaultsKeys.lastAssignedOrderNumber)
        return orderNumber
    }
    
    var residenceTimeInSeconds: Int? {
        if let departureDate = departureDate, let arrivalDate = arrivalDate {
            let roundedDepartureDate = Calendar.current.date(bySetting: .second, value: 0, of: departureDate)!
            let roundedArrivalDate = Calendar.current.date(bySetting: .second, value: 0, of: arrivalDate)!
            return Int(roundedDepartureDate.timeIntervalSince(roundedArrivalDate))
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
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    struct UserDefaultsKeys {
        static let lastAssignedOrderNumber = "lastOrderNumber"
    }
    
    init() {
        self.id = idGenerator.uuidString
        
        self.orderNumber = RoutePointVM.nextOrderNumber
        
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

func ==(lhs: RoutePoint, rhs: RoutePoint) -> Bool
{
    return lhs.id == rhs.id
}
