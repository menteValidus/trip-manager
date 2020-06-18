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
    var center = CLLocationCoordinate2D()
    var southWestCoordinate = CLLocationCoordinate2D()
    var northEastCoordinate = CLLocationCoordinate2D()
    
    init(from decoder: Decoder) throws {
        if let featureContainer = try? decoder.container(keyedBy: FeatureKeys.self) {
            self.name = try featureContainer.decode(String.self, forKey: .name)
            
            let coordinateValues = try featureContainer.decode([Double].self, forKey: .center)
            let longitude = coordinateValues.first!
            let latitude = coordinateValues.last!
            center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            if let boundBoxCoordinates = try? featureContainer.decode([Double].self, forKey: .bbox) {
                southWestCoordinate = CLLocationCoordinate2D(latitude: boundBoxCoordinates[1], longitude: boundBoxCoordinates[0])
                northEastCoordinate = CLLocationCoordinate2D(latitude: boundBoxCoordinates[3], longitude: boundBoxCoordinates[2])
            } else {
                southWestCoordinate = center
                northEastCoordinate = center
            }
        }
    }
    
    private enum FeatureKeys: String, CodingKey {
        case name = "place_name"
        case center
        case bbox
    }
}
