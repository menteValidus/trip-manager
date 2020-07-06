//
//  UtilTests.swift
//  UtilTests
//
//  Created by Denis Cherniy on 24.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import XCTest
@testable import TripManager

class UtilTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFormatMetres() {
        var metresToFormat = 1234
        XCTAssertEqual(format(metres: metresToFormat), "1 km 234 m")
        
        metresToFormat = 0
        XCTAssertEqual(format(metres: metresToFormat), "")
        
        metresToFormat = 1
        XCTAssertEqual(format(metres: metresToFormat), "1 m")
        
        metresToFormat = 1000
        XCTAssertEqual(format(metres: metresToFormat), "1 km")
    }

    struct TimeUnits {
        static let second = 1
        static let minute = 60 * second
        static let hour = 60 * minute
        static let day = 24 * hour
        static let week = 7 * day
    }
    
    func testFormatSeconds() {
        // Minute's check
        var secondsToFormat = TimeUnits.minute
        XCTAssertEqual(format(seconds: secondsToFormat), "1 min")
        
        secondsToFormat = 3 * TimeUnits.minute + 5 * TimeUnits.second
        XCTAssertEqual(format(seconds: secondsToFormat), "3 min")
        
        // Hour's check
        secondsToFormat = TimeUnits.hour
        XCTAssertEqual(format(seconds: secondsToFormat), "1 h")
        
        secondsToFormat = 3 * TimeUnits.hour + 5 * TimeUnits.minute
        XCTAssertEqual(format(seconds: secondsToFormat), "3 h 5 min")
        
        // Day's check
        secondsToFormat = TimeUnits.day
        XCTAssertEqual(format(seconds: secondsToFormat), "1 d")
        
        secondsToFormat = 3 * TimeUnits.day + 5 * TimeUnits.hour
        XCTAssertEqual(format(seconds: secondsToFormat), "3 d 5 h")
        
        secondsToFormat = 3 * TimeUnits.day + 5 * TimeUnits.hour + 6 * TimeUnits.minute + 7 * TimeUnits.second
        XCTAssertEqual(format(seconds: secondsToFormat), "3 d 5 h 6 min")
        
        // Week's check
        secondsToFormat = TimeUnits.week
        XCTAssertEqual(format(seconds: secondsToFormat), "1 w")
        
        secondsToFormat = 2 * TimeUnits.week + 3 * TimeUnits.day
        XCTAssertEqual(format(seconds: secondsToFormat), "2 w 3 d")
        
        secondsToFormat = 2 * TimeUnits.week + 3 * TimeUnits.day + 5 * TimeUnits.hour
        XCTAssertEqual(format(seconds: secondsToFormat), "2 w 3 d 5 h")
        
        secondsToFormat = 2 * TimeUnits.week + 3 * TimeUnits.day + 5 * TimeUnits.hour + 6 * TimeUnits.minute + 7 * TimeUnits.second
        XCTAssertEqual(format(seconds: secondsToFormat), "2 w 3 d 5 h 6 min")
    }
}
