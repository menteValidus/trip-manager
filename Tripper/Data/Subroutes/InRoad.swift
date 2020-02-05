//
//  Road.swift
//  Tripper
//
//  Created by Denis Cherniy on 05.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

class InRoad: Subroute {
    var title: String
    var timeInMinutes: Int
    
    init(title: String = "In Road", minutes: Int) {
        self.title = title
        timeInMinutes = minutes
    }
}
