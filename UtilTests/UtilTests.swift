//
//  UtilTests.swift
//  UtilTests
//
//  Created by Denis Cherniy on 24.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import XCTest
@testable import Tripper

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

}
