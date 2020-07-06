//
//  RoutePointEntity+CoreDataProperties.swift
//  
//
//  Created by Denis Cherniy on 22.06.2020.
//
//

import Foundation
import CoreData


extension RoutePointEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutePointEntity> {
        return NSFetchRequest<RoutePointEntity>(entityName: "RoutePointEntity")
    }

    @NSManaged public var arrivalDate: Date
    @NSManaged public var departureDate: Date
    @NSManaged public var id: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var orderNumber: Int32
    @NSManaged public var subtitle: String
    @NSManaged public var title: String
    @NSManaged public var isFinished: Bool
    @NSManaged public var nextFragment: RouteFragmentEntity?
    @NSManaged public var previousFragment: RouteFragmentEntity?

}
