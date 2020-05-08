//
//  RouteFragmentEntity+CoreDataProperties.swift
//  
//
//  Created by Denis Cherniy on 08.05.2020.
//
//

import Foundation
import CoreData


extension RouteFragmentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteFragmentEntity> {
        return NSFetchRequest<RouteFragmentEntity>(entityName: "RouteFragmentEntity")
    }

    @NSManaged public var distanceInMeters: Int64
    @NSManaged public var timeInSeconds: Int64
    @NSManaged public var coordinates: NSSet?
    @NSManaged public var nextFragmentOf: RoutePointEntity
    @NSManaged public var previousFragmentOf: RoutePointEntity

}

// MARK: Generated accessors for coordinates
extension RouteFragmentEntity {

    @objc(addCoordinatesObject:)
    @NSManaged public func addToCoordinates(_ value: CoordinateEntity)

    @objc(removeCoordinatesObject:)
    @NSManaged public func removeFromCoordinates(_ value: CoordinateEntity)

    @objc(addCoordinates:)
    @NSManaged public func addToCoordinates(_ values: NSSet)

    @objc(removeCoordinates:)
    @NSManaged public func removeFromCoordinates(_ values: NSSet)

}
