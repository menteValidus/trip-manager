//
//  Date+ComparisonWithoutSeconds.swift
//  Tripper
//
//  Created by Denis Cherniy on 21.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

extension Date {
    func compareWithoutSeconds(with date: Date) -> ComparisonResult {
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let selfDate = calendar.date(from: dateComponents)!
        
        dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let comparingDate = calendar.date(from: dateComponents)!
        
        return selfDate.compare(comparingDate)
    }
}
