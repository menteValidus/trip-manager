//
//  CoreDataDAO.swift
//  Tripper
//
//  Created by Denis Cherniy on 11.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreData

class CoreDataDAO: RoutePointDAO {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataModelDB.Name)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                throwAn(error: error)
            }
        })
        
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    
    struct DataModelDB {
        static let Name = "DataModel"
        
        struct Entities {
            
            struct RoutePointEntity {
                static let Name = "RoutePointEntity"
                
                struct KeyPathNames {
                    static let ID = "id"
                    static let Longitude = "longitude"
                    static let Latitude = "latitude"
                    static let TimeInMinutes = "timeInMinutes"
                    static let Title = "title"
                    static let Subtitle = "subtitle"
                }
            }
        }
    }
    
    // MARK: - Database's Queries
    
    func fetchAll() -> [RoutePoint] {
        let pointsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RoutePointEntity.Name)
        let fetchedPoints: [RoutePointEntity]
        do {
            fetchedPoints = try managedObjectContext.fetch(pointsFetch) as! [RoutePointEntity]
        } catch {
            throwAn(error: error)
            fetchedPoints = []
        }
        
        var routePoints: [RoutePoint] = []
        
        for pointEntity in fetchedPoints {
            routePoints.append(convertEntityToRoutePoint(pointEntity))
        }
        
        return routePoints
    }
    
    func insert(_ point: RoutePoint) {
        let entity = NSEntityDescription.entity(forEntityName: DataModelDB.Entities.RoutePointEntity.Name, in: managedObjectContext)!
        
        let routePointObject = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! RoutePointEntity
        routePointObject.setValue(point.id, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.ID)
        routePointObject.setValue(point.longitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Longitude)
        routePointObject.setValue(point.latitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Latitude)
        routePointObject.setValue(point.residenceTimeInMinutes, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.TimeInMinutes)
        routePointObject.setValue(point.title ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Title)
        routePointObject.setValue(point.subtitle ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Subtitle)

        
        do {
            try managedObjectContext.save()
        } catch {
            throwAn(error: error)
        }
        
    }
    
    func update(_ point: RoutePoint) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: DataModelDB.Entities.RoutePointEntity.Name)
        fetchRequest.predicate = NSPredicate(format: "id = %@", point.id)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            
            if let pointToUpdate = fetchResult.first as? RoutePointEntity {
                pointToUpdate.setValue(point.id, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.ID)
                pointToUpdate.setValue(point.longitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Longitude)
                pointToUpdate.setValue(point.latitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Latitude)
                pointToUpdate.setValue(point.residenceTimeInMinutes, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.TimeInMinutes)
                pointToUpdate.setValue(point.title ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Title)
                pointToUpdate.setValue(point.subtitle ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Subtitle)
                
                try managedObjectContext.save()
            } else {
                throwAn(errorMessage: "There is no way we can be here!!!")
            }
        } catch {
            throwAn(error: error)
        }
    }
    
    func delete(_ point: RoutePoint) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: DataModelDB.Entities.RoutePointEntity.Name)
        fetchRequest.predicate = NSPredicate(format: "id = %@", point.id)
        
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            
            let pointToDelete = fetchResult.first as! RoutePointEntity
            managedObjectContext.delete(pointToDelete)
            
            try managedObjectContext.save()
            
        } catch {
            throwAn(error: error)
        }
    }
    
    // MARK: - Converters
    
    private func convertEntityToRoutePoint(_ entity: RoutePointEntity) -> RoutePoint {
        let point = RoutePoint(id: entity.id!, longitude: entity.longitude, latitude: entity.latitude, title: entity.title ?? "", subtitle: entity.subtitle ?? "")
        return point
    }
//
//    private func convertRoutePointToEntity(_ routePoint: RoutePoint) -> RoutePointEntity {
//        let entity = RoutePointEntity(context: managedObjectContext)
//
//    }
}
