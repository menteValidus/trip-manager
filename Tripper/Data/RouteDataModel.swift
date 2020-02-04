//
//  RouteDataModel.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import MapKit

class RouteDataModel {
    private(set) var points: [RoutePoint] = []
    var overlays: [MKPolyline] = []
    
    private(set) var length = 0.0
    
    init() {
        loadFromDocuments()
    }
    
    // MARK: - Helper Methods
    
    func clear() {
        points.removeAll()
        overlays.removeAll()
    }
    
    func add(point: RoutePoint) {
        points.append(point)
    }
    
    // MARK: - Save/Load Utility
    
    func saveInDocuments() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(points)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            display(message: "Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadFromDocuments() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                points = try decoder.decode([RoutePoint].self, from: data)
            } catch {
                display(message: "Error decoding item array: \(error.localizedDescription)")
            }
            
        }
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Route.plist")
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
