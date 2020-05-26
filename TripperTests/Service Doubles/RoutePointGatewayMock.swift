//
//  RoutePointGatewayMock.swift
//  TripperTests
//
//  Created by Denis Cherniy on 14.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import Tripper
import Foundation

class RoutePointGatewayMock: RoutePointDataStore {
    
    var storage: [RoutePoint]
    
    init(initialStorage: [RoutePoint]) {
        storage = initialStorage
    }
    
    func fetchAll() -> [RoutePoint] {
        return storage
    }
    
    func fetch(with identifier: String) -> RoutePoint? {
        return nil
    }
    
    func deleteAll() {
        
    }
    
    var insertedRoutePoint: RoutePoint?
    
    func insert(_ point: RoutePoint) {
        insertedRoutePoint = point
    }
    
    var updatedRoutePoint: RoutePoint?
    
    func update(_ point: RoutePoint) {
        updatedRoutePoint = point
    }
    
    var deletedRoutePoint: RoutePoint?
    
    func delete(_ point: RoutePoint) {
        deletedRoutePoint = point
    }
    
}
