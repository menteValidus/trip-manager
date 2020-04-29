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
    func presentFetchDifference(response: ManageRouteMap.FetchDifference.Response)
    func presentCreateRoutePoint(response: ManageRouteMap.CreateRoutePoint.Response)
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response)
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response)
    func presentDeselectAnnotation(response: ManageRouteMap.DeselectAnnotation.Response)
    func presentShowDetail(response: ManageRouteMap.ShowDetail.Response)
    func presentEditRoutePoint(response: ManageRouteMap.EditRoutePoint.Response)
    func presentDeleteRoutePoint(response: ManageRouteMap.DeleteAnnotation.Response)
    func presentCreateRouteFragment(response: ManageRouteMap.CreateRouteFragment.Response)
    func presentDeleteRouteFragment(response: ManageRouteMap.DeleteRouteFragment.Response)
    func presentMapRoute(response: ManageRouteMap.MapRoute.Response)
    func presentClearAll(response: ManageRouteMap.ClearAll.Response)
    func presentToggleUserInput(response: ManageRouteMap.ToggleUserInput.Response)
    func presentFocusOnRoute(response: ManageRouteMap.FocusOnRoute.Response)
    func presentFocusOnUser(response: ManageRouteMap.FocusOnUser.Response)
    func presentRouteEstimation(response: ManageRouteMap.RouteEstimation.Response)
}

class ManageRouteMapPresenter: ManageRouteMapPresentationLogic {
    weak var viewController: ManageRouteMapDisplayLogic?
    
    // MARK: Annotation Creation
    
    func presentCreateRoutePoint(response: ManageRouteMap.CreateRoutePoint.Response) {
        let viewModel = ManageRouteMap.CreateRoutePoint.ViewModel(isSucceed: response.isSucceed)
        viewController?.displayCreateRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Set Route Point
    
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response) {
        let viewModel = ManageRouteMap.SetRoutePoint.ViewModel(annotationInfo: response.annotationInfo)
        viewController?.displaySetRoutePoint(viewModel: viewModel)
    }
    
    // MARK: Fetch Difference
    
    func presentFetchDifference(response: ManageRouteMap.FetchDifference.Response) {
        let viewModel = ManageRouteMap.FetchDifference.ViewModel(newAnnotationsInfo: response.newAnnotationsInfo, removedAnnotationsInfo: response.removedAnnotationInfo)
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
        let viewModel = ManageRouteMap.CreateRouteFragment.ViewModel(routeFragment: response.routeFragment)
        viewController?.displayCreateRouteFragment(viewModel: viewModel)
    }
    
    // MARK: Delete Route Fragment
    
    func presentDeleteRouteFragment(response: ManageRouteMap.DeleteRouteFragment.Response) {
        let viewModel = ManageRouteMap.DeleteRouteFragment.ViewModel(identifier: response.identifier)
        viewController?.displayDeleteRouteFragment(viewModel: viewModel)
    }
    
    // MARK: Map Route
    
    func presentMapRoute(response: ManageRouteMap.MapRoute.Response) {
        let viewModel = ManageRouteMap.MapRoute.ViewModel(addedSubroutesInfo: response.addedSubroutesInfo,
                                                          idsOfDeletedRouteFragments: response.idsOfDeletedRouteFragments)
        viewController?.displayMapRoute(viewModel: viewModel)
    }
    
    // MARK: Clear All
    
    func presentClearAll(response: ManageRouteMap.ClearAll.Response) {
        let viewModel = ManageRouteMap.ClearAll.ViewModel()
        viewController?.displayClearAll(viewModel: viewModel)
    }
    
    // MARK: Block User Input
    
    func presentToggleUserInput(response: ManageRouteMap.ToggleUserInput.Response) {
        let viewModel = ManageRouteMap.ToggleUserInput.ViewModel(isLocked: response.isLocked)
        viewController?.displayToggleUserInput(viewModel: viewModel)
    }
    
    // MARK: Focus On Route
    
    func presentFocusOnRoute(response: ManageRouteMap.FocusOnRoute.Response) {
        let viewModel = ManageRouteMap.FocusOnRoute.ViewModel(
            southWestCoordinate: response.southWestCoordinate, northEastCoordinate: response.northEastCoordinate)
        viewController?.displayFocusOnRoute(viewModel: viewModel)
    }
    
    // MARK: Focus On User
    
    func presentFocusOnUser(response: ManageRouteMap.FocusOnUser.Response) {
        let viewModel = ManageRouteMap.FocusOnUser.ViewModel(userCoordinate: response.userCoordinate)
        viewController?.displayFocusOnUser(viewModel: viewModel)
    }
    
    // MARK: Route Estimation
    
    func presentRouteEstimation(response: ManageRouteMap.RouteEstimation.Response) {
        let timeEstimation = format(seconds: response.timeInSeconds)
        let distanceEstimation = format(metres: response.distanceInMeters)
        
        if timeEstimation.isEmpty && distanceEstimation.isEmpty {
            let viewModel = ManageRouteMap.RouteEstimation.ViewModel(toShow: false, timeEstimation: timeEstimation,
                                                                     distanceEstimation: distanceEstimation)
            viewController?.displayRouteEstimation(viewModel: viewModel)
            return
        }
        
        if timeEstimation.isEmpty && !distanceEstimation.isEmpty {
            let viewModel = ManageRouteMap.RouteEstimation.ViewModel(toShow: true, timeEstimation: "Several seconds",
                                                                     distanceEstimation: distanceEstimation)
            viewController?.displayRouteEstimation(viewModel: viewModel)
            return
        }
        
        if !timeEstimation.isEmpty && distanceEstimation.isEmpty {
            let viewModel = ManageRouteMap.RouteEstimation.ViewModel(toShow: true, timeEstimation: timeEstimation,
                                                                     distanceEstimation: "Several metres")
            viewController?.displayRouteEstimation(viewModel: viewModel)
            return
        }
        
        let viewModel = ManageRouteMap.RouteEstimation.ViewModel(toShow: true, timeEstimation: timeEstimation,
                                                                 distanceEstimation: distanceEstimation)
        viewController?.displayRouteEstimation(viewModel: viewModel)
    }
}