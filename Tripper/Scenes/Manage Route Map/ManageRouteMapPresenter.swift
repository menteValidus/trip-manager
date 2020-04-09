//
//  ManageRouteMapPresenter.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.04.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ManageRouteMapPresentationLogic {
    func presentFetchNewAnnotationsInfo(response: ManageRouteMap.FetchNewAnnotationsInfo.Response)
    func presentAnnotationCreation(response: ManageRouteMap.CreateRoutePoint.Response)
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response)
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response)
}

class ManageRouteMapPresenter: ManageRouteMapPresentationLogic {
    weak var viewController: ManageRouteMapDisplayLogic?
    
    // MARK: Annotation creation
    
    func presentAnnotationCreation(response: ManageRouteMap.CreateRoutePoint.Response) {
        let viewModel = ManageRouteMap.CreateRoutePoint.ViewModel()
        viewController?.displayCreateRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Set route point
    
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response) {
        let viewModel = ManageRouteMap.SetRoutePoint.ViewModel(annotationInfo: response.annotationInfo)
        viewController?.displaySetRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Fetch new annotations info
    
    func presentFetchNewAnnotationsInfo(response: ManageRouteMap.FetchNewAnnotationsInfo.Response) {
        let viewModel = ManageRouteMap.FetchNewAnnotationsInfo.ViewModel(annotationsInfo: response.annotationsInfo)
        viewController?.displayFetchNewAnnotationsInfo(viewModel: viewModel)
    }
    
    // MARK: Select annotation
    
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response) {
        let viewModel = ManageRouteMap.SelectAnnotation.ViewModel(identifier: response.identifier)
        viewController?.displaySelectAnnotation(viewModel: viewModel)
    }
}
