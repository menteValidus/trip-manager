//
//  File.swift
//  Tripper
//
//  Created by Denis Cherniy on 17.06.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

protocol SearchApiGateway {
    func performSearch(with query: String, completion: @escaping ([PointInfo]) -> Void)
}

class MapboxSearchApiGateway: SearchApiGateway {
    private let urlBase = "https://api.mapbox.com/" + "geocoding/v5/mapbox.places/"
    private let apiKey = "pk.eyJ1IjoibWVudGV2YWxpZHVzIiwiYSI6ImNrNncxOWV2ODA3YTczbG12aXA0ejNhcjUifQ.R7n2xz3GEAa_DLv_MX4Wbg"
    
    func performSearch(with query: String, completion: @escaping ([PointInfo]) -> Void) {
        let urlString =  urlBase + "\(query).json" + "?access_token=\(apiKey)"
        if  let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, res, err in
                if let data = data {
                    print("*** Started decoding")
                    
                    let decoder = JSONDecoder()
                    if let searchResult = try? decoder.decode(SearchResult.self, from: data) {
                        completion(searchResult.pointsInfo)
                    }
                }
            }.resume()
        }
    }
}
