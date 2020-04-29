//
//  RouteFragmentCoreDataStore.swift
//  Tripper
//
//  Created by Denis Cherniy on 29.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreData

protocol RouteFragmentDataStore: class {
}

class RouteFragmentCoreDataStore: RouteFragmentDataStore {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataModelDB.name)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                throwAn(error: error)
            }
        })
        
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    
    private struct DataModelDB {
        static let name = "DataModel"
        
        struct Entities {
            
            struct RouteFragmentEntity {
                static let name = "RouteFragmentEntity"
                
                struct KeyPathNames {
                    static let id = "id"
                    static let coordinates = "coordinates"
                    static let time = "timeInSeconds"
                    static let distance = "distanceInMeters"
                }
            }
        }
    }
    
    // MARK: - Database's Queries
    
    func fetchAll() -> [RouteFragment] {
        let pointsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RouteFragmentEntity.name)
        let fetchedPoints: [RouteFragmentEntity]
        do {
            fetchedPoints = try managedObjectContext.fetch(pointsFetch) as! [RouteFragmentEntity]
        } catch {
            fatalError("*** Failed to fetch all RoutePoint's date.\n\(error)")
        }
        
        var routeFragments: [RouteFragment] = []
        
        for fragmentEntity in fetchedPoints {
            routeFragments.append(convertEntityToRoutePoint(fragmentEntity))
        }
        
        return routeFragments
    }
    
    func insert(_ fragment: RouteFragment) {
        let entity = NSEntityDescription.entity(forEntityName: DataModelDB.Entities.RouteFragmentEntity.name, in: managedObjectContext)!
        
        let routeFragmentObject = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! RouteFragmentEntity
        configure(entity: routeFragmentObject, with: fragment)
        
        do {
            try managedObjectContext.save()
        } catch {
            throwAn(error: error)
        }
    }
    
    func delete(_ fragment: RouteFragment) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: DataModelDB.Entities.RouteFragmentEntity.name)
        fetchRequest.predicate = NSPredicate(format: "id = %@", fragment.identifier)
        
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            
            let pointToDelete = fetchResult.first as! RouteFragmentEntity
            managedObjectContext.delete(pointToDelete)
            
            try managedObjectContext.save()
            
        } catch {
            fatalError("Delete's Error: \(error)")
        }
    }
//
//    func deleteAll() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RoutePointEntity.name)
//
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try managedObjectContext.execute(batchDeleteRequest)
//        } catch {
//            fatalError("Clear's Error: \(error)")
//        }
//    }
    
    // MARK: - Converters
    
    private func convertEntityToRoutePoint(_ entity: RouteFragmentEntity) -> RouteFragment {
        let routeFragment = ConcreteRouteFragment(identifier: entity.id!, coordinates: [/*TODO*/], travelTimeInSeconds: Int(entity.timeInSeconds), travelDistanceInMeters: Int(entity.distanceInMeters))
        return routeFragment
    }
    
    // MARK: Configurators
    
    private func configure(entity: RouteFragmentEntity, with routeFragment: RouteFragment) {
        entity.setValue(routeFragment.identifier, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.id)
        entity.setValue(routeFragment.coordinates, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.coordinates)
        entity.setValue(routeFragment.travelTimeInSeconds, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.time)
        entity.setValue(routeFragment.travelDistanceInMeters, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.distance)
    }
    
}
