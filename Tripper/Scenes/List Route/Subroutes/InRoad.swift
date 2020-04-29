//
//  Road.swift
//  Tripper
//
//  Created by Denis Cherniy on 05.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

class InRoad: Subroute {
    private static let defaultTitle = "In Road"
    var title: String
    var timeInSeconds: Int
    var metres: Int
    
    init(title: String = defaultTitle, seconds: Int, metres: Int) {
        self.title = title
        timeInSeconds = seconds
        self.metres = metres
    }
}
