//
//  Util.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()


func throwAn(error: Error) {
    print("*** Error: \(error)")
    fatalError("Could not load data store: \(error)")
}

func display(message: String) {
    print("*** \(message)")
}
