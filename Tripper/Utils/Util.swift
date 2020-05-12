//
//  Util.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import UIKit

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

func format(firstID: String, secondID: String) -> String {
    return "\(firstID)-\(secondID)"
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
    
    return formattedTime//.isEmpty ? "Several seconds" : formattedTime
}

struct DistanceUnits {
    static let meter = 1
    static let kilometer = 1000 * meter
}

func format(metres: Int) -> String {
    var formattedDistance = ""
    let kilometers = metres / DistanceUnits.kilometer
    
    if kilometers > 0 {
        formattedDistance.append("\(kilometers) km")
    }
    
    let remainedMeters = metres % DistanceUnits.kilometer
    
    if remainedMeters > 0 {
        if !formattedDistance.isEmpty {
            formattedDistance.append(" ")
        }
        formattedDistance.append("\(remainedMeters) m")
    }
    
    return formattedDistance//.isEmpty ? "Several meters" : formattedDistance
}
