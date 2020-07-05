//
//  FastNavigationWorker.swift
//  Tripper
//
//  Created by Denis Cherniy on 19.05.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

class FastNavigationWorker {
    private let routePointGateway: RoutePointGateway
    private let routeFragmentGateway: RouteFragmentGateway
    
    init(routePointGateway: RoutePointGateway, routeFragmentGateway: RouteFragmentGateway) {
        self.routePointGateway = routePointGateway
        self.routeFragmentGateway = routeFragmentGateway
    }
    
    func fetchSubroutes() -> [Subroute] {
        let stayings = fetchStayings()
        let inRoads = fetchInRoads()
        
        var subroutes = [Subroute]()
        let count = stayings.count + inRoads.count
        
        guard count > 0 else { return [] }
        
        for index in 0..<(stayings.count + inRoads.count) {
            if index % 2 == 0 {
                subroutes.append(stayings[index / 2])
            } else {
                subroutes.append(inRoads[index / 2])
            }
        }
        
        return subroutes
    }
    
    func fetchStayings() -> [FastNavigation.Staying] {
        var stayings = [FastNavigation.Staying]()
        
        let fetchedRoutePoints = routePointGateway.fetchAll()
        
        for routePoint in fetchedRoutePoints {
            let timeToStayInSeconds = Int(routePoint.departureDate.timeIntervalSince(routePoint.arrivalDate))
            let coordinate = CLLocationCoordinate2D(latitude: routePoint.latitude, longitude: routePoint.longitude)
            let staying = FastNavigation.Staying(title: routePoint.title, timeInSeconds: timeToStayInSeconds, description: routePoint.subtitle, coordinate: coordinate)
            stayings.append(staying)
        }
        
        return stayings
    }
    
    func fetchInRoads() -> [FastNavigation.InRoad] {
        var subroutes = [FastNavigation.InRoad]()
        
        let fetchedRouteFragments = routeFragmentGateway.fetchAll()
        
        for routeFragment in fetchedRouteFragments {
            let inRoad = FastNavigation.InRoad(timeInSeconds: routeFragment.travelTimeInSeconds,
                                               metres: routeFragment.travelDistanceInMeters,
                                               coordinates: routeFragment.coordinates)
            subroutes.append(inRoad)
        }
        
        return subroutes
    }
}