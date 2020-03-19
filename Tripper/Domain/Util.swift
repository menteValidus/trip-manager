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

func format(minutes: Int) -> String {
    
    if minutes % 60 == 0 {
        return "\(minutes / 60) h"
    } else if minutes < 60 {
        return "\(minutes) min"
    } else  {
        return "\(minutes / 60) h \(minutes % 60) min"
    }
}

func format(metres: Int) -> String {
    if metres % 1000 == 0 {
        return "\(metres / 1000) km"
    } else if metres < 1000 {
        return "\(metres) m"
    } else {
        return "\(metres / 1000) km \(metres % 1000) m"
    }
}
