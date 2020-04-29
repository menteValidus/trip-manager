//
//  RouteFragmentEntity+CoreDataProperties.swift
//  
//
//  Created by Denis Cherniy on 29.04.2020.
//
//

import Foundation
import CoreData


extension RouteFragmentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteFragmentEntity> {
        return NSFetchRequest<RouteFragmentEntity>(entityName: "RouteFragmentEntity")
    }

    @NSManaged public var coordinates: NSObject?
    @NSManaged public var timeInSeconds: Int64
    @NSManaged public var distanceInMeters: Int64
    @NSManaged public var id: String?

}
