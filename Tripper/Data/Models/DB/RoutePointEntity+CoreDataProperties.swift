//
//  RoutePointEntity+CoreDataProperties.swift
//  Tripper
//
//  Created by Denis Cherniy on 13.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//
//

import Foundation
import CoreData


extension RoutePointEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutePointEntity> {
        return NSFetchRequest<RoutePointEntity>(entityName: "RoutePointEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var subtitle: String?
    @NSManaged public var timeInMinutes: Int32
    @NSManaged public var title: String?

}
