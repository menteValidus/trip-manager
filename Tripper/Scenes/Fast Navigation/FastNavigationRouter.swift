//
//  FastNavigationRouter.swift
//  Tripper
//
//  Created by Denis Cherniy on 19.05.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol FastNavigationRoutingLogic {
    func routeToManageRouteMap(segue: UIStoryboardSegue?)
}

protocol FastNavigationDataPassing {
    var dataStore: FastNavigationDataStore? { get }
}

class FastNavigationRouter: FastNavigationRoutingLogic, FastNavigationDataPassing {
    weak var viewController: FastNavigationViewController?
    var dataStore: FastNavigationDataStore?
    
    // MARK: Routing
    
    func routeToManageRouteMap(segue: UIStoryboardSegue?) {
        if let destinationVC = viewController?.parent as? ManageRouteMapViewController {
            var destinationDS = destinationVC.router!.dataStore!
            passDataToManageRouteMap(source: dataStore!, destination: &destinationDS)
            navigateToManageRouteMap(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToManageRouteMap(source: FastNavigationViewController, destination: ManageRouteMapViewController)
    {
        source.removeFromParent()
        UIView.animate(withDuration: 0.3, animations: {
            source.view.frame = source.view.frame.offsetBy(dx: source.view.frame.width, dy: 0)
        }, completion: { _ in
            source.view.removeFromSuperview()
            destination.fastNavigationPopup = nil
        })
    }
    
    // MARK: Passing Data
    
    func passDataToManageRouteMap(source: FastNavigationDataStore, destination: inout ManageRouteMapDataStore) {
        
    }
}
