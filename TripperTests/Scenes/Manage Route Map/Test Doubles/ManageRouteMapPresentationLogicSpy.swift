//
//  ManageRouteMapPresentationLogicSpy.swift
//  TripperTests
//
//  Created by Denis Cherniy on 14.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//
@testable import Tripper

class ManageRouteMapPresentationLogicSpy: ManageRouteMapPresentationLogic {
    var viewController: ManageRouteMapDisplayLogic!
    
    func presentDataSetup(response: ManageRouteMap.SetupData.Response) {
    }
    
    func presentFetchDifference(response: ManageRouteMap.FetchDifference.Response) {
    }
    
    func presentCreateRoutePoint(response: ManageRouteMap.CreateRoutePoint.Response) {
        viewController.displayCreateRoutePoint(viewModel: .init(isSucceed: response.isSucceed))
    }
    
    func presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response) {
    }
    
    func presentSelectAnnotation(response: ManageRouteMap.SelectAnnotation.Response) {
    }
    
    func presentDeselectAnnotation(response: ManageRouteMap.DeselectAnnotation.Response) {
    }
    
    func presentShowDetail(response: ManageRouteMap.ShowDetail.Response) {
    }
    
    func presentEditRoutePoint(response: ManageRouteMap.EditRoutePoint.Response) {
    }
    
    func presentDeleteRoutePoint(response: ManageRouteMap.DeleteAnnotation.Response) {
    }
    
    func presentCreateRouteFragment(response: ManageRouteMap.CreateRouteFragment.Response) {
    }
    
    func presentAddedRouteFragment(response: ManageRouteMap.AddRouteFragment.Response) {
    }
    
    func presentDeleteRouteFragment(response: ManageRouteMap.DeleteRouteFragment.Response) {
    }
    
    func presentMapRoute(response: ManageRouteMap.MapRoute.Response) {
    }
    
    func presentClearAll(response: ManageRouteMap.ClearAll.Response) {
    }
    
    func presentToggleUserInput(response: ManageRouteMap.ToggleUserInput.Response) {
    }
    
    func presentFocus(response: ManageRouteMap.Focus.Response) {
    }
    
    func presentFocusOnRoute(response: ManageRouteMap.FocusOnRoute.Response) {
    }
    
    func presentFocusOnUser(response: ManageRouteMap.FocusOnUser.Response) {
    }
    
    func presentRouteEstimation(response: ManageRouteMap.RouteEstimation.Response) {
    }
}
