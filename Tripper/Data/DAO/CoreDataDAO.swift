//
//  CoreDataDAO.swift
//  Tripper
//
//  Created by Denis Cherniy on 11.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreData

class CoreDataRoutePointDAO: RoutePointDAO {
    
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
            
            struct RoutePointEntity {
                static let name = "RoutePointEntity"
                
                struct KeyPathNames {
                    static let ID = "id"
                    static let Longitude = "longitude"
                    static let Latitude = "latitude"
                    static let TimeInMinutes = "timeInMinutes"
                    static let Title = "title"
                    static let Subtitle = "subtitle"
                    static let arrivalDate = "arrivalDate"
                    static let departureDate = "departureDate"
                }
            }
        }
    }
    
    // MARK: - Database's Queries
    
    func fetchAll() -> [RoutePoint] {
        let pointsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RoutePointEntity.name)
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
        let entity = NSEntityDescription.entity(forEntityName: DataModelDB.Entities.RoutePointEntity.name, in: managedObjectContext)!
        
        let routePointObject = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! RoutePointEntity
        configure(entity: routePointObject, with: point)
        
        do {
            try managedObjectContext.save()
        } catch {
            throwAn(error: error)
        }
        
    }
    
    func update(_ point: RoutePoint) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: DataModelDB.Entities.RoutePointEntity.name)
        fetchRequest.predicate = NSPredicate(format: "id = %@", point.id)
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest)
            
            if let pointToUpdate = fetchResult.first as? RoutePointEntity {
                configure(entity: pointToUpdate, with: point)
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
            NSFetchRequest.init(entityName: DataModelDB.Entities.RoutePointEntity.name)
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
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RoutePointEntity.name)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            throwAn(errorMessage: "CoreDataDAO.clearRoutePointEntity error: \(error)")
        }
    }
    
    // MARK: - Converters
    
    private func convertEntityToRoutePoint(_ entity: RoutePointEntity) -> RoutePoint {
        let point = RoutePoint(id: entity.id!, orderNumber: Int(entity.orderNumber), longitude: entity.longitude, latitude: entity.latitude, title: entity.title ?? "", subtitle: entity.subtitle ?? "")
        point.arrivalDate = entity.arrivalDate
        point.departureDate = entity.departureDate
        return point
    }
    
    private func configure(entity: RoutePointEntity, with routePoint: RoutePoint) {
        entity.setValue(routePoint.id, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.ID)
        entity.setValue(routePoint.longitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Longitude)
        entity.setValue(routePoint.latitude, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Latitude)
        entity.setValue(routePoint.residenceTimeInMinutes, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.TimeInMinutes)
        entity.setValue(routePoint.title ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Title)
        entity.setValue(routePoint.subtitle ?? "", forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.Subtitle)
        entity.setValue(routePoint.arrivalDate, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.arrivalDate)
        entity.setValue(routePoint.departureDate, forKey: DataModelDB.Entities.RoutePointEntity.KeyPathNames.departureDate)
//        return entity
    }
//
//    private func convertRoutePointToEntity(_ routePoint: RoutePoint) -> RoutePointEntity {
//        let entity = RoutePointEntity(context: managedObjectContext)
//
//    }
}
