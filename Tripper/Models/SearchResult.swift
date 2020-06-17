//
//  SearchResult.swift
//  Tripper
//
//  Created by Denis Cherniy on 16.06.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import CoreLocation

struct SearchResult: Decodable {
    var pointsInfo: [PointInfo] = []
    
    init(from decoder: Decoder) throws {
        if let searchResultContainer = try? decoder.container(keyedBy: SearchResultKeys.self) {
            pointsInfo = try searchResultContainer.decode([PointInfo].self, forKey: .features)
        }
    }
    
    private enum SearchResultKeys: String, CodingKey {
        case features
    }
}

struct PointInfo: Codable {
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    init(from decoder: Decoder) throws {
        if let featureContainer = try? decoder.container(keyedBy: FeatureKeys.self) {
            self.name = try featureContainer.decode(String.self, forKey: .name)
            let coordinate = try featureContainer.decode([Double].self, forKey: .center)
            self.latitude = coordinate.last!
            self.longitude = coordinate.first!
        }
    }
    
    private enum FeatureKeys: String, CodingKey {
            case name = "place_name"
            case center
    }
}
