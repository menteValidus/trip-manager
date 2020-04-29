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
    var timeInSeconds: Int
    var description: String
    
    init(title: String, seconds: Int, description: String) {
        self.title = title
        timeInSeconds = seconds
        self.description = description
    }
}
