//
//  ManageRouteMapWorker.swift
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

/// Created and deleted Route Points.
typealias FetchedDifference = ([ManageRouteMap.ConcreteAnnotationInfo], [String])

class ManageRouteMapWorker {
    private let routePointGateway: RoutePointDataStore = RoutePointCoreDataStore()
    
    func fetchNewAnnotationsInfo(comparingWith idList: [String]) -> FetchedDifference {
        let fetchedRoutePoints = routePointGateway.fetchAll()
        let (newAnnotationsInfo, idsOfRemovedRP) = findNewData(within: fetchedRoutePoints, with: idList)
        
        return (newAnnotationsInfo, idsOfRemovedRP)
    }
    
    private func findNewData(within routePoints: [RoutePoint], with idList: [String]) -> FetchedDifference {
        var newAnnotationsInfo = [ManageRouteMap.ConcreteAnnotationInfo]()
        var idsOfExistedRoutePoints = idList
        
        routePoints.forEach() { routePoint in
            // Check whether this element already displayed.
            let isContained = idsOfExistedRoutePoints.contains(where: {
                return $0 == routePoint.id
            })
            
            let annotationInfo = convertRoutePointToAnnotationInfo(routePoint: routePoint)
            
            if !isContained {
                newAnnotationsInfo.append(annotationInfo)
            } else {
                // Remove this id from check list.
                let index = idsOfExistedRoutePoints.firstIndex(of: routePoint.id)
                idsOfExistedRoutePoints.remove(at: index!)
            }
        }
        
        return (newAnnotationsInfo, idsOfExistedRoutePoints)
    }
    
    private func convertRoutePointToAnnotationInfo(routePoint: RoutePoint) -> ManageRouteMap.ConcreteAnnotationInfo {
        let annotationInfo = ManageRouteMap.ConcreteAnnotationInfo(id: routePoint.id, orderNumber: routePoint.orderNumber,
                                                                   latitude: routePoint.latitude, longitude: routePoint.longitude)
        return annotationInfo
    }
    
    // TODO: Temporal.
    func fetchRoutePoint(with id: String) -> RoutePoint {
        return routePointGateway.fetch(with: id)!
    }
}
