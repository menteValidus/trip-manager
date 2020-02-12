//
//  PropertyListDAO.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

class PropertyListDAO {
    let plistName: String
    
    struct Names {
        static let PlistName = "Route"
    }
    
    init() {
        plistName = "\(Names.PlistName).plist"
    }
    
    // MARK: - Save/Load Utility
    
    func save(_ points: [RoutePoint]) {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(points)
//            try data.write(to: dataFilePath(), options: .atomic)
//        } catch {
//            display(message: "Error encoding item array: \(error.localizedDescription)")
//        }
    }
    
    func load() -> [RoutePoint] {
//        let path = dataFilePath()
//        
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                let points = try decoder.decode([RoutePoint].self, from: data)
//                return points
//            } catch {
//                display(message: "Error decoding item array: \(error.localizedDescription)")
//            }
//            
//        }
//        
        return []
    }
    
    // MARK: - Helper Methods
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Route.plist")
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
