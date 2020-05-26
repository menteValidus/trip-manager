//
//  DetailRoutePointRouterMock.swift
//  TripperTests
//
//  Created by Denis Cherniy on 26.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import Tripper
import UIKit

class DetailRoutePointRouterMock: NSObject, DetailRoutePointRoutingLogic, DetailRoutePointDataPassing {
    var dataStore: DetailRoutePointDataStore?
    
    func routeToManageRouteMap(segue: UIStoryboardSegue?) {
        
    }
    
    func routeToManageRouteMapWithEdit(segue: UIStoryboardSegue?) {
        
    }
    
    func routeToManageRouteMapWithDelete(segue: UIStoryboardSegue?) {
        
    }
}
