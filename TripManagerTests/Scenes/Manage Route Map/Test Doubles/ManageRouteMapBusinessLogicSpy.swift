//
//  ManageRouteMapBusinessLogicSpy.swift
//  TripperTests
//
//  Created by Denis Cherniy on 14.05.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

@testable import TripManager

class ManageRouteMapBusinessLogicSpy: ManageRouteMapBusinessLogic {
    func updateRouteProgress(request: ManageRouteMap.UpdateRouteProgress.Request) {
        
    }
    
    func createTemporaryPoint(request: ManageRouteMap.CreateTemporaryPoint.Request) {
        
    }
    
    func removeTemporaryPoint(request: ManageRouteMap.RemoveTemporaryPoint.Request) {
        
    }
    
    var presenter: ManageRouteMapPresentationLogic!
    var worker: ManageRouteMapWorker!
    
    func setupData(request: ManageRouteMap.SetupData.Request) {
    }
    
    func fetchDifference(request: ManageRouteMap.FetchDifference.Request) {
    }
    
    func createRoutePoint(request: ManageRouteMap.CreateRoutePoint.Request) {
        presenter.presentCreateRoutePoint(response: .init(isSucceed: true))
    }
    
    func setRoutePoint(request: ManageRouteMap.SetRoutePoint.Request) {
    }
    
    func selectAnnotation(request: ManageRouteMap.SelectAnnotation.Request) {
    }
    
    func deselectAnnotation(request: ManageRouteMap.DeselectAnnotation.Request) {
    }
    
    func showDetail(request: ManageRouteMap.ShowDetail.Request) {
    }
    
    func editRoutePoint(request: ManageRouteMap.EditRoutePoint.Request) {
    }
    
    func deleteRoutePoint(request: ManageRouteMap.DeleteAnnotation.Request) {
    }
    
    func createRouteFragment(request: ManageRouteMap.CreateRouteFragment.Request) {
    }
    
    func addRouteFragment(request: ManageRouteMap.AddRouteFragment.Request) {
    }
    
    func deleteRouteFragment(request: ManageRouteMap.DeleteRouteFragment.Request) {
    }
    
    func mapRoute(request: ManageRouteMap.MapRoute.Request) {
    }
    
    func clearAll(request: ManageRouteMap.ClearAll.Request) {
    }
    
    func toggleUserInput(request: ManageRouteMap.ToggleUserInput.Request) {
    }
    
    func focus(request: ManageRouteMap.Focus.Request) {
    }
    
    func focusOnRoute(request: ManageRouteMap.FocusOnRoute.Request) {
    }
    
    func focusOnUser(request: ManageRouteMap.FocusOnUser.Request) {
    }
    
    func focusOnCoordinates(request: ManageRouteMap.FocusOnCoordinates.Request) {
        
    }
    
    func routeEstimation(request: ManageRouteMap.RouteEstimation.Request) {
    }
    
}
