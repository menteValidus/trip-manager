//
//  RouteFragmentGatewayMock.swift
//  TripperTests
//
//  Created by Denis Cherniy on 14.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import TripManager
import Foundation

class RouteFragmentGatewayMock: RouteFragmentGateway {
    
    var storage: [RouteFragment]
    
    init(initialStorage: [RouteFragment]) {
        storage = initialStorage
    }
    
    func fetchAll() -> [RouteFragment] {
        return storage
    }
    
    func insert(_ fragment: RouteFragment) {
        
    }
}
