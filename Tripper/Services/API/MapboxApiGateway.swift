//
//  File.swift
//  Tripper
//
//  Created by Denis Cherniy on 17.06.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

protocol SearchApiGateway {
}

class MapboxSearchApiGateway: SearchApiGateway {
    private let apiKey = "pk.eyJ1IjoibWVudGV2YWxpZHVzIiwiYSI6ImNrNncxOWV2ODA3YTczbG12aXA0ejNhcjUifQ.R7n2xz3GEAa_DLv_MX4Wbg"
    
    func get() {
        let urlString = "https://api.mapbox.com/" + "geocoding/v5/mapbox.places/" + "новошахтинск щорса 16.json" + "?access_token=\(apiKey)"
        if  let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, res, err in
                if let data = data {
                    print("*** Started decoding")
                    
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(SearchResult.self, from: data) {
                        print(json)
                    }
                }
            }.resume()
        }
    }
}
