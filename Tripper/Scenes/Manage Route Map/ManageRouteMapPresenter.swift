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
    func presentFetchDifference(response: ManageRouteMap.FetchNewAnnotationsInfo.Response)
    func presentAnnotationCreation(response: ManageRouteMap.CreateRoutePoint.Response)
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response)
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response)
    func presentDeselectAnnotation(response: ManageRouteMap.DeselectAnnotation.Response)
    func presentShowDetail(response: ManageRouteMap.ShowDetail.Response)
    func presentEditRoutePoint(response: ManageRouteMap.EditRoutePoint.Response)
    func presentDeleteRoutePoint(response: ManageRouteMap.DeleteAnnotation.Response)
    func presentCreateRouteFragment(response: ManageRouteMap.CreateRouteFragment.Response)
    func presentDeleteRouteFragment(response: ManageRouteMap.DeleteRouteFragment.Response)
    func presentMapRoute(response: ManageRouteMap.MapRoute.Response)
}

class ManageRouteMapPresenter: ManageRouteMapPresentationLogic {
    weak var viewController: ManageRouteMapDisplayLogic?
    
    // MARK: Annotation Creation
    
    func presentAnnotationCreation(response: ManageRouteMap.CreateRoutePoint.Response) {
        let viewModel = ManageRouteMap.CreateRoutePoint.ViewModel()
        viewController?.displayCreateRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Set Route Point
    
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response) {
        let viewModel = ManageRouteMap.SetRoutePoint.ViewModel(annotationInfo: response.annotationInfo)
        viewController?.displaySetRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Fetch Difference
    
    func presentFetchDifference(response: ManageRouteMap.FetchNewAnnotationsInfo.Response) {
        let viewModel = ManageRouteMap.FetchNewAnnotationsInfo.ViewModel(newAnnotationsInfo: response.newAnnotationsInfo, idsOfRemovedRoutePoints: response.idsOfRemovedRoutePoints)
        viewController?.displayFetchDifference(viewModel: viewModel)
    }
    
    // MARK: Select Annotation
    
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response) {
        let viewModel = ManageRouteMap.SelectAnnotation.ViewModel(identifier: response.identifier)
        viewController?.displaySelectAnnotation(viewModel: viewModel)
    }
    
    // MARK: Deselect Annotation
    
    func presentDeselectAnnotation(response: ManageRouteMap.DeselectAnnotation.Response) {
        let viewModel = ManageRouteMap.DeselectAnnotation.ViewModel()
        viewController?.displayDeselectAnnotation(viewModel: viewModel)
    }
    
    // MARK: Show Detail
    
    func presentShowDetail(response: ManageRouteMap.ShowDetail.Response) {
        let viewModel = ManageRouteMap.ShowDetail.ViewModel()
        viewController?.displayShowDetail(viewModel: viewModel)
    }
    
    // MARK: Edit Route Point
    
    func presentEditRoutePoint(response: ManageRouteMap.EditRoutePoint.Response) {
        let viewModel = ManageRouteMap.EditRoutePoint.ViewModel()
        viewController?.displayEditRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Delete Route Point
    
    func presentDeleteRoutePoint(response: ManageRouteMap.DeleteAnnotation.Response) {
        let viewModel = ManageRouteMap.DeleteAnnotation.ViewModel(identifier: response.identifier)
        viewController?.displayDeleteRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Create Route Fragment
    
    func presentCreateRouteFragment(response: ManageRouteMap.CreateRouteFragment.Response) {
        
    }
    
    // MARK: Delete Route Fragment
    
    func presentDeleteRouteFragment(response: ManageRouteMap.DeleteRouteFragment.Response) {
        
    }
    
    // MARK: Map Route
    
    func presentMapRoute(response: ManageRouteMap.MapRoute.Response) {
        let viewModel = ManageRouteMap.MapRoute.ViewModel(addedSubroutesInfo: response.addedSubroutesInfo,
                                                          idsOfDeletedRouteFragments: response.idsOfDeletedRouteFragments)
        viewController?.displayMapRoute(viewModel: viewModel)
        // TODO: Implement:
        // If there's waiting for result show LoadingView and call Map Route use case
        // Else if it's route fragment creation call dedicated use case or if it's route fragment deletion call Delete use case
        // and then call Map Route use case to disable LoadingView.
    }
}
