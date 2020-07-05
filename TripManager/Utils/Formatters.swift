//
//  Util.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import UIKit

// MARK: IDs Formatter

func format(firstID: String, secondID: String) -> String {
    return "\(firstID)-\(secondID)"
}

// MARK: Time Formatter

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

// MARK: Distance Formatter

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
    
    return formattedDistance
}
