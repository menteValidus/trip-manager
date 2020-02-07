//
//  RouteDataModel.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import MapKit

class RouteDataModel {
    private(set) var points: [RoutePoint] = []
    var overlays: [MKPolyline] = []
    
    private(set) var length = 0.0
    
    // Subroute means any division of main route. i.e. Stop in city for 2 days, road between points for 3 hours.
    var countSubroutes: Int {
        // This formula calculate overall number of route points and roads.
        return points.count * 2 - 1
    }
    
    init() {
        loadFromDocuments()
    }
    
    // MARK: - Helper Methods
    
    func clear() {
        points.removeAll()
        overlays.removeAll()
    }
    
    func add(point: RoutePoint) {
        points.append(point)
    }
    
    func getSubroute(at index: Int) -> Subroute {
        // We divide index by 2 to conform index of route point in points array.
        let i = index / 2
        let point = points[i]
        
        if index % 2 == 0 {
            return Staying(title: point.title ?? "Staying #\(i)", minutes: point.residenceTimeInMinutes!)
        } else {
            return InRoad(minutes: point.timeToGetToNextPointInMinutes!)
        }
    }
    
    
}
