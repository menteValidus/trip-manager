//
//  RouteFragmentCoreDataStore.swift
//  Tripper
//
//  Created by Denis Cherniy on 29.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

protocol RouteFragmentDatastore: class {
    func fetchAll() -> [RouteFragment]
    func insert(_ fragment: RouteFragment)
}

class RouteFragmentCoreDataStore: RouteFragmentDatastore {
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        return NSManagedObjectContext.shared
    }()
    
    private let routePointGateway: RoutePointDataStore
    
    init(routePointGateway: RoutePointDataStore) {
        self.routePointGateway = routePointGateway
    }
    
    // MARK: - Database's Queries
    
    func fetchAll() -> [RouteFragment] {
        let pointsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RouteFragmentEntity.name)
        let fetchedPoints: [RouteFragmentEntity]
        do {
            fetchedPoints = try managedObjectContext.fetch(pointsFetch) as! [RouteFragmentEntity]
        } catch {
            fatalError("*** Failed to fetch all RoutePoint's date.\nError:\(error)")
        }
        
        var routeFragments: [RouteFragment] = []
        
        for fragmentEntity in fetchedPoints {
            routeFragments.append(convertEntityToRouteFragment(fragmentEntity))
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
            fatalError("Insert's Error: \(error)")
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
    
    // MARK: - Converters
    
    private func convertEntityToRouteFragment(_ entity: RouteFragmentEntity) -> RouteFragment {
        let previousPointID = entity.nextFragmentOf.id
        let nextPointID = entity.previousFragmentOf.id
        var coordinates = [CLLocationCoordinate2D]()
        
        if let coordEntities = entity.coordinates {
            let orderedCoordinates = coordEntities.sorted(by: { lhs, rhs in
                let lhsCoord = lhs as! CoordinateEntity
                let rhsCoord = rhs as! CoordinateEntity
                
                if (lhsCoord.orderNumber > rhsCoord.orderNumber) {
                    return true
                }
                
                return false
            })
            
            for coordinateEntity in orderedCoordinates {
                let coordinate = convertEntityToCoordinate(coordinateEntity as! CoordinateEntity)
                coordinates.append(coordinate)
            }
        }
        
        let routeFragment = ConcreteRouteFragment(startPointID: previousPointID, endPointID: nextPointID, coordinates: coordinates, travelTimeInSeconds: Int(entity.timeInSeconds), travelDistanceInMeters: Int(entity.distanceInMeters))

        return routeFragment
    }
    
    private func convertEntityToCoordinate(_ entity: CoordinateEntity) -> CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(entity.latitude), longitude: CLLocationDegrees(entity.longitude))
        return coordinate
    }
    
    private func convertCoordinateToEntity(_ coordinate: CLLocationCoordinate2D) -> CoordinateEntity {
        let entity = CoordinateEntity(context: managedObjectContext)
        entity.latitude = Float(coordinate.latitude)
        entity.longitude = Float(coordinate.longitude)
        return entity
    }
    
    // MARK: Configurators
    
    private func configure(entity: RouteFragmentEntity, with routeFragment: RouteFragment) {
        entity.setValue(routeFragment.travelTimeInSeconds, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.time)
        entity.setValue(routeFragment.travelDistanceInMeters, forKey: DataModelDB.Entities.RouteFragmentEntity.KeyPathNames.distance)
        let startPoint = fetchRoutePointEntity(with: routeFragment.startPointID)!
        entity.nextFragmentOf = startPoint
        let endPoint = fetchRoutePointEntity(with: routeFragment.endPointID)!
        entity.previousFragmentOf = endPoint
        
        var orderNumber = 1
        for coordinate in routeFragment.coordinates {
            let coordEntity = convertCoordinateToEntity(coordinate)
            coordEntity.orderNumber = Int64(orderNumber)
            coordEntity.ofFragment = entity
            orderNumber += 1
        }
    }
    
    // MARK: Helper Methods
    
    private func fetchRoutePointEntity(with identifier: String) -> RoutePointEntity? {
        let pointFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataModelDB.Entities.RoutePointEntity.name)
        let predicate = NSPredicate(format: "\(DataModelDB.Entities.RoutePointEntity.KeyPathNames.id) = %@", identifier)
        pointFetch.predicate = predicate
        
        let fetchedPoint: RoutePointEntity?
        do {
            fetchedPoint = try (managedObjectContext.fetch(pointFetch) as! [RoutePointEntity]).first
        } catch {
            fatalError("*** Failed to fetch RoutePoint with id: \(identifier).\n\(error)")
        }
        
        return fetchedPoint
    }
    
}
