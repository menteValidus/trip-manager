//
//  OrderNumberGeneratorMock.swift
//  TripperTests
//
//  Created by Denis Cherniy on 26.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import Tripper

class OrderNumberGeneratorMock: OrderNumberGenerator {
    func getNewOrderNumber() -> Int {
        return 1
    }
}
