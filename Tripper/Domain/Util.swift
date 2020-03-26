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

struct TimeUnits {
    static let second = 1
    static let minute = 60 * second
    static let hour = 60 * minute
    static let day = 24 * hour
    static let week = 7 * day
}


func format(seconds: Int) -> String {
    var formattedTime = ""
    let weeks = seconds / TimeUnits.week
    
    if weeks > 0 {
        formattedTime.append("\(weeks) w")
    }
    
    var remainedSeconds = seconds % TimeUnits.week
    let days = remainedSeconds / TimeUnits.day
    
    if days > 0 {
        if !formattedTime.isEmpty {
            formattedTime.append(" ")
        }
        formattedTime.append("\(days) d")
    }
    
    remainedSeconds %= TimeUnits.day
    let hours = remainedSeconds / TimeUnits.hour
    
    if hours > 0 {
        if !formattedTime.isEmpty {
            formattedTime.append(" ")
        }
        formattedTime.append("\(hours) h")
    }
    
    remainedSeconds %= TimeUnits.hour
    let minutes = remainedSeconds / TimeUnits.minute
    
    if minutes > 0 {
        if !formattedTime.isEmpty {
            formattedTime.append(" ")
        }
        formattedTime.append("\(minutes) min")
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
