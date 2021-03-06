//
//  SearchPresenter.swift
//  Tripper
//
//  Created by Denis Cherniy on 16.06.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

protocol SearchPresentationLogic {
    func presentPerformedSearch(response: Search.PerformSearch.Response)
    func presentEntrySelection(response: Search.SelectEntry.Response)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    // MARK: Perform Search
    
    func presentPerformedSearch(response: Search.PerformSearch.Response) {
        let points = response.pointsInfo.map({ $0.name })
        DispatchQueue.main.async {
            self.viewController?.displayPerformedSearch(viewModel: .init(points: points))
        }
    }
    
    // MARK: Select Entry
    
    func presentEntrySelection(response: Search.SelectEntry.Response) {
        viewController?.displayEntrySelection(viewModel: .init(title: response.title, center: response.center,
                                                               southWestCoordinate: response.southWestCoordinate,
                                                               northSouthCoordinate: response.northSouthCoordinate))
    }
}
