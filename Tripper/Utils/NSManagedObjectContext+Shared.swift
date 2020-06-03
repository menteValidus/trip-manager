//
//  NSManagedObjectContext+Shared.swift
//  Tripper
//
//  Created by Denis Cherniy on 08.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreData

struct DataModelDB {
    static let name = "DataModel"
    
    struct Entities {
        
        struct RoutePointEntity {
            static let name = "RoutePointEntity"
            
            struct KeyPathNames {
                static let id = "id"
                static let longitude = "longitude"
                static let latitude = "latitude"
                static let orderNumber = "orderNumber"
                static let title = "title"
                static let subtitle = "subtitle"
                static let arrivalDate = "arrivalDate"
                static let departureDate = "departureDate"
                static let distanceToNextPointInMeters = "distanceToNextPointInMeters"
                static let timeToNextPointInSeconds = "timeToNextPointInSeconds"
            }
        }
        
        struct RouteFragmentEntity {
            static let name = "RouteFragmentEntity"
            
            struct KeyPathNames {
                static let id = "id"
                static let coordinates = "coordinates"
                static let time = "timeInSeconds"
                static let distance = "distanceInMeters"
            }
        }
        
        struct CoordinateEntity {
            static let name = "CoordinateEntity"
            
            struct KeyPathNames {
                static let orderNumber = "orderNumber"
                static let latitude = "latitude"
                static let longitude = "longitude"
            }
        }
            
    }
}


extension NSManagedObjectContext {

    static var shared: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: DataModelDB.name)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                fatalError("*** Error at loading persisten store. Error:\n\(error)")
            }
        })
        
        return container.viewContext
    }()
    
}
