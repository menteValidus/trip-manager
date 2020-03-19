//
//  Stay.swift
//  Tripper
//
//  Created by Denis Cherniy on 05.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation


class Staying: Subroute {    
    var title: String
    var timeInMinutes: Int
    var description: String
    
    init(title: String, seconds: Int, description: String) {
        self.title = title
        timeInMinutes = seconds / 60
        self.description = description
    }
    
    // MARK: - Factory
    
    struct Factory {
        static func create(from routePoint: RoutePoint) -> Staying {
            return Staying(title: routePoint.title ?? "", seconds: routePoint.residenceTimeInSeconds ?? 0, description: routePoint.subtitle ?? "")
        }
    }
}
