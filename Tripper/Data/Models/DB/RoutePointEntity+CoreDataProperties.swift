//
//  RoutePointEntity+CoreDataProperties.swift
//  
//
//  Created by Denis Cherniy on 06.03.2020.
//
//

import Foundation
import CoreData


extension RoutePointEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutePointEntity> {
        return NSFetchRequest<RoutePointEntity>(entityName: "RoutePointEntity")
    }

    @NSManaged public var arrivalDate: Date?
    @NSManaged public var departureDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var orderNumber: Int32
    @NSManaged public var subtitle: String?
    @NSManaged public var distanceToNextPointInMeters: Int32
    @NSManaged public var title: String?
    @NSManaged public var timeToNextPointInSeconds: Int32

}
