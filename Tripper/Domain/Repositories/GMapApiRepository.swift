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
    private let session = URLSession.shared
    private var tasks: [URLSessionDataTask] = []
    
    // MARK: - Helper Methods
    
    func fetchDirection(sourceCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D,
                        handler: @escaping (_ polylineString: String) -> Void) {
        let apiRequestString = GMapApiRepository.createRequestUrl(sourceCoord: sourceCoord, destinationCoord: destinationCoord)
        
        let task = session.dataTask(with: apiRequestString) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                guard let jsonResult = json else {
                    display(message: "Unparseable response: \(String(describing: json))")
                    return
                }
                
                guard let routes = jsonResult["routes"] as? [Any] else {
                    return
                }
                
                guard let route = routes[0] as? [String: Any] else {
                    return
                }

                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }

                guard let polylineString = overview_polyline["points"] as? String else {
                    return
                }

                handler(polylineString)
                
                display(message: "\(String(describing: json))")
            } catch {
                throwAn(errorMessage: "GMapApiRepository.fetchDirection error: \(error)")
            }
        }
        
        tasks.append(task)
    }
    
    private static func createRequestUrl(sourceCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D) -> URL {
        let originSubstring = "origin=\(sourceCoord.latitude),\(sourceCoord.longitude)"
        let destinationSubstring = "destination=\(destinationCoord.latitude),\(destinationCoord.longitude)"
        let requestString = "https://maps.googleapis.com/maps/api/directions/json?\(originSubstring)&\(destinationSubstring)&key=\(GMapApiRepository.apiKey)"
        let url = URL(string: requestString)!
        return url
    }
    
    func stopFetching() {
        tasks.forEach {
            $0.cancel()
        }
    }
    
}
