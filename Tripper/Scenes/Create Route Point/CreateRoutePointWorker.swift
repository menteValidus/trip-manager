//
//  CreateRoutePointWorker.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.04.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class CreateRoutePointWorker {
    private let routePointGateway: RoutePointGateway
    private let orderNumberGenerator: OrderNumberGenerator
    private let dateLimiter: DateLimiter
    
    init(routePointGateway: RoutePointGateway, orderNumberGenerator: OrderNumberGenerator, dateLimiter: DateLimiter) {
        self.routePointGateway = routePointGateway
        self.orderNumberGenerator = orderNumberGenerator
        self.dateLimiter = dateLimiter
    }
    
    func save(routePoint: RoutePoint) {
        let routePoints = routePointGateway.fetchAll()
        
        let alreadyCreated = routePoints.contains(where: {
            return $0.id == routePoint.id
        })
        
        if alreadyCreated {
            update(routePoint: routePoint)
        } else {
            insert(routePoint: routePoint)
        }
    }
    
    func insert(routePoint: RoutePoint) {
        routePointGateway.insert(routePoint)
    }
    
    func update(routePoint: RoutePoint) {
        routePointGateway.update(routePoint)
    }
    
    func getNewOrderNumber() -> Int {
        return orderNumberGenerator.getNewOrderNumber()
    }
    
    func getLeftDateLimit(by orderNumber: Int) -> Date? {
        let leftLimit = dateLimiter.fetchLeftLimit(by: orderNumber)
        return leftLimit
    }
    
    func getRightDateLimit(by orderNumber: Int) -> Date? {
        let rightLimit = dateLimiter.fetchRightLimit(by: orderNumber)
        return rightLimit
    }
}
