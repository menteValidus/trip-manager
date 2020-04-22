//
//  DetailRoutePointRouter.swift
//  Tripper
//
//  Created by Denis Cherniy on 09.04.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DetailRoutePointRoutingLogic {
    func routeToManageRouteMap(segue: UIStoryboardSegue?)
    func routeToManageRouteMapWithEdit(segue: UIStoryboardSegue?)
    func routeToManageRouteMapWithDelete(segue: UIStoryboardSegue?)
}

protocol DetailRoutePointDataPassing {
    var dataStore: DetailRoutePointDataStore? { get }
}

class DetailRoutePointRouter: NSObject, DetailRoutePointRoutingLogic, DetailRoutePointDataPassing {
    weak var viewController: DetailRoutePointViewController?
    var dataStore: DetailRoutePointDataStore?
    
    // MARK: Routing
    
    func routeToManageRouteMap(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ManageRouteMapViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToManageRouteMap(source: dataStore!, destination: &destinationDS)
        } else {
            let destinationVC = viewController?.parent as! ManageRouteMapViewController
            var destinationDS = destinationVC.router!.dataStore! 
            passDataToManageRouteMap(source: dataStore!, destination: &destinationDS)
            navigateToManageRouteMap(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToManageRouteMapWithEdit(segue: UIStoryboardSegue?) {
        let destinationVC = viewController?.parent as! ManageRouteMapViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToManageRouteMapWithEdit(source: dataStore!, destination: &destinationDS)
        navigateToManageRouteMapWithEdit(source: viewController!, destination: destinationVC)
    }
    
    func routeToManageRouteMapWithDelete(segue: UIStoryboardSegue?) {
        let destinationVC = viewController?.parent as! ManageRouteMapViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToManageRouteMapWithDelete(source: dataStore!, destination: &destinationDS)
        navigateToManageRouteMapWithDelete(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToManageRouteMap(source: DetailRoutePointViewController, destination: ManageRouteMapViewController)
    {
        source.removeFromParent()
        UIView.animate(withDuration: 0.3, animations: {
            source.view.frame = CGRect(x: 0, y: destination.view.frame.height, width: destination.view.frame.width, height: source.view.frame.height)
        }, completion: { _ in
            source.view.removeFromSuperview()
            destination.popup = nil
        })
    }
    
    func navigateToManageRouteMapWithEdit(source: DetailRoutePointViewController, destination: ManageRouteMapViewController)
    {
        source.removeFromParent()
        UIView.animate(withDuration: 0.3, animations: {
            source.view.frame = CGRect(x: 0, y: destination.view.frame.height, width: destination.view.frame.width, height: source.view.frame.height)
        }, completion: { _ in
            source.view.removeFromSuperview()
            destination.popup = nil
            // TODO: Need to get rid of this dependency.
            destination.editSelectedRoutePoint()
        })
    }
    
    func navigateToManageRouteMapWithDelete(source: DetailRoutePointViewController, destination: ManageRouteMapViewController)
    {
        source.removeFromParent()
        UIView.animate(withDuration: 0.3, animations: {
            source.view.frame = CGRect(x: 0, y: destination.view.frame.height, width: destination.view.frame.width, height: source.view.frame.height)
        }, completion: { _ in
            source.view.removeFromSuperview()
            destination.popup = nil
        })
    }
    
    // MARK: Passing data
    
    func passDataToManageRouteMap(source: DetailRoutePointDataStore, destination: inout ManageRouteMapDataStore) {
    }
    
    func passDataToManageRouteMapWithEdit(source: DetailRoutePointDataStore, destination: inout ManageRouteMapDataStore) {
    }
    
    func passDataToManageRouteMapWithDelete(source: DetailRoutePointDataStore, destination: inout ManageRouteMapDataStore) {
    }
}
