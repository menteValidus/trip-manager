//
//  Util.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import UIKit

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()


func throwAn(error: Error) {
    print("*** Error: \(error)")
    fatalError("Error: \(error)")
}

func throwAn(errorMessage: String) {
    print("*** \(errorMessage)")
    fatalError(errorMessage)
}

func display(message: String) {
    print("*** \(message)")
}

let MINUTE = 1
let MINUTES_IN_HOUR = 60 * MINUTE
let MINUTES_IN_DAY = 24 * MINUTES_IN_HOUR

func format(minutes: Int) -> String {
    var formattedTime = ""
    let days = minutes / MINUTES_IN_DAY
    
    if days > 0 {
        formattedTime.append("\(days) d")
    }
    
    var remainedMinutes = minutes % MINUTES_IN_DAY
    let hours = remainedMinutes / MINUTES_IN_HOUR
    
    if hours > 0 {
        if !formattedTime.isEmpty {
            formattedTime.append(" ")
        }
        formattedTime.append("\(hours) h")
    }
    
    remainedMinutes %= MINUTES_IN_HOUR
    
    if remainedMinutes > 0 {
        if !formattedTime.isEmpty {
            formattedTime.append(" ")
        }
        formattedTime.append("\(remainedMinutes) min")
    }
    
    return formattedTime
}

let METER = 1
let KILOMETER = 1000 * METER

func format(metres: Int) -> String {
    var formattedDistance = ""
    let kilometers = metres / KILOMETER
    
    if kilometers > 0 {
        formattedDistance.append("\(kilometers) km")
    }
    
    let remainedMeters = metres % KILOMETER
    
    if remainedMeters > 0 {
        if !formattedDistance.isEmpty {
            formattedDistance.append(" ")
        }
        formattedDistance.append("\(remainedMeters) m")
    }
    
    return formattedDistance
}
