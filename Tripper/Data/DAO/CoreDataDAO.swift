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
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                throwAn(error: error)
            }
        })
        
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    struct EntitiesNames {
        static let RoutePoint = "RoutePointEntity"
    }
    
    // MARK: - Database's Queries
    
    func selectAll() -> [RoutePoint] {
        let pointsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: EntitiesNames.RoutePoint)
        let fetchedPoints: [RoutePointEntity]
        do {
            fetchedPoints = try managedObjectContext.fetch(pointsFetch) as! [RoutePointEntity]
        } catch {
            throwAn(error: error)
            fetchedPoints = []
        }
        
        var routePoints: [RoutePoint] = []
        
        for pointEntity in fetchedPoints {
            routePoints.append(convertToRoutePoint(pointEntity))
        }
        
        return routePoints
    }
    
    func insert(_ point: RoutePoint) {
        
    }
    
    func update(_ point: RoutePoint) {
        
    }
    
    func delete(_ point: RoutePoint) {
        
    }
    
    // MARK: - Helper Methods
    
    private func convertToRoutePoint(_ entity: RoutePointEntity) -> RoutePoint {
        let point = RoutePoint(longitude: entity.longitude, latitude: entity.latitude, title: entity.title ?? "", subtitle: entity.subtitle ?? "")
        return point
    }
    
}
