//
//  GMapApiRepository.swift
//  Tripper
//
//  Created by Denis Cherniy on 19.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import CoreLocation

class GMapApiRepository {
    private static let apiKey = "AIzaSyA53BgLa8gZcYkfXYaZvt4qBPU5wnZPY0Y"
    private let apiRequestString: URL
    private let session = URLSession.shared
    private var tasks: [URLSessionDataTask] = []
    
    init(sourceCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) {
        apiRequestString = GMapApiRepository.createRequestUrl(sourceCoord: sourceCoord, destinationCoord: destinationCoord)
    }
    
    // MARK: - Helper Methods
    
    private static func createRequestUrl(sourceCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) -> URL {
        let originSubstring = "origin=\(sourceCoord.latitude),\(sourceCoord.longitude)"
        let destinationSubstring = "destination=\(destinationCoord.latitude),\(destinationCoord.longitude)"
        let requestString = "https://maps.googleapis.com/maps/api/directions/json?\(originSubstring)&\(destinationSubstring)&key=\(GMapApiRepository.apiKey)"
        return URL(string: requestString)!
    }
    
    func fetchDirection(handler: () -> Void) {
        let task = session.dataTask(with: apiRequestString) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                guard let jsonResult = json else {
                    display(message: "Unparseable response: \(String(describing: json))")
                    return
                }
                
                
                display(message: "\(json)")
            } catch {
                throwAn(errorMessage: "GMapApiRepository.fetchDirection error: \(error)")
            }
        }
        
        tasks.append(task)
    }
    
}
