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
    
    func insert(_ point: RoutePoint) {
        
    }
    
    func update(_ point: RoutePoint) {
        
    }
    
    func delete(_ point: RoutePoint) {
        
    }
    
}
