//
//  DateLimiterMock.swift
//  TripperTests
//
//  Created by Denis Cherniy on 26.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import TripManager
import Foundation

class DateLimiterMock: DateLimiter {
    func fetchLeftLimit(by orderNumber: Int) -> Date? {
        return Date()
    }
    
    func fetchRightLimit(by orderNumber: Int) -> Date? {
        return Date()
    }
}
