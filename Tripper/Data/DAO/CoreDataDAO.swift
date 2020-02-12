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
    
    func selectAll() -> [RoutePoint] {
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
        
        let routePointObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
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
        
    }
    
    func delete(_ point: RoutePoint) {
        
    }
    
    // MARK: - Converters
    
    private func convertEntityToRoutePoint(_ entity: RoutePointEntity) -> RoutePoint {
        let point = RoutePoint(longitude: entity.longitude, latitude: entity.latitude, title: entity.title ?? "", subtitle: entity.subtitle ?? "")
        return point
    }
//
//    private func convertRoutePointToEntity(_ routePoint: RoutePoint) -> RoutePointEntity {
//        let entity = RoutePointEntity(context: managedObjectContext)
//
//    }
}
