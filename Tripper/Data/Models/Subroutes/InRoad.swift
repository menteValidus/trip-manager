//
//  Road.swift
//  Tripper
//
//  Created by Denis Cherniy on 05.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

class InRoad: Subroute {
    private static var defaultTitle = "In Road"
    var title: String
    var timeInMinutes: Int
    var metres: Int
    
    init(title: String = defaultTitle, minutes: Int, metres: Int) {
        self.title = title
        timeInMinutes = minutes
        self.metres = metres
    }
    
    init(title: String = defaultTitle, seconds: Int, metres: Int) {
        self.title = title
        timeInMinutes = seconds / 60
        self.metres = metres
    }
}
