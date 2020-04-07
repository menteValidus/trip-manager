//
//  IDGenerator.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

protocol IDGenerator {
    func generate() -> String
}

class NSUUIDGenerator: IDGenerator {
    private static var _instance: NSUUIDGenerator?
    private let idGenerator: NSUUID

    private init() {
        idGenerator = NSUUID()
    }
    
    static var instance: IDGenerator = {
        if let instance = _instance {
            return instance
        } else {
            _instance = NSUUIDGenerator()
            return _instance!
        }
    }()
        
    func generate() -> String {
        let id = idGenerator.uuidString
        return id
    }
}
