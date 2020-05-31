//
//  SwinjectContainer+Shared.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Swinject

extension Container {
    static let shared: Container = {
        let container = Container()
        
        container.register(RoutePointGateway.self) { _ in RoutePointCoreDataGateway()}
        container.register(RouteFragmentGateway.self) { _ in
            guard let routePointGateway = container.resolve(RoutePointGateway.self) else {
                fatalError("*** RoutePointGateway can't be resolved!")
            }
            
            return RouteFragmentCoreDataGateway(routePointGateway: routePointGateway)
        }
        
        container.register(DateLimiter.self) { _ in
            guard let routePointCoreDataStore = container.resolve(RoutePointGateway.self) as? RoutePointCoreDataGateway else {
                fatalError("*** RoutePointGateway can't be resolved")
            }
            
            return routePointCoreDataStore
        }
        
        container.register(OrderNumberGenerator.self) { _ in
            guard let routePointCoreDataStore = container.resolve(RoutePointGateway.self) as? RoutePointCoreDataGateway else {
                fatalError("*** RoutePointGateway can't be resolved")
            }
            
            return routePointCoreDataStore
        }
        
        container.register(RouteCreator.self) { _ in MapboxRouteCreator() }
        
        return container
    }()
}
