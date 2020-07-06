//
//  CoordinateEntity+CoreDataProperties.swift
//  
//
//  Created by Denis Cherniy on 08.05.2020.
//
//

import Foundation
import CoreData


extension CoordinateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordinateEntity> {
        return NSFetchRequest<CoordinateEntity>(entityName: "CoordinateEntity")
    }

    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var orderNumber: Int64
    @NSManaged public var ofFragment: RouteFragmentEntity?

}
