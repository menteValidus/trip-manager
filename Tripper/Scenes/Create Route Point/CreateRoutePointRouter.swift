//
//  CreateRoutePointRouter.swift
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

@objc protocol CreateRoutePointRoutingLogic {
    func routeToManageRouteMap(segue: UIStoryboardSegue?)
}

protocol CreateRoutePointDataPassing {
    var dataStore: CreateRoutePointDataStore? { get }
}

class CreateRoutePointRouter: NSObject, CreateRoutePointRoutingLogic, CreateRoutePointDataPassing {
    weak var viewController: CreateRoutePointViewController?
    var dataStore: CreateRoutePointDataStore?
    
    // MARK: Routing
    
    func routeToManageRouteMap(segue: UIStoryboardSegue?)
    {
      if let segue = segue {
        let destinationVC = segue.destination as! ManageRouteMapViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
      } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ManageRouteMapViewController") as! ManageRouteMapViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
      }
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: CreateRoutePointViewController, destination: ManageRouteMapViewController)
    {
        source.navigationController?.popViewController(animated: true) {
            destination.showDetail()
        }
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: CreateRoutePointDataStore, destination: inout ManageRouteMapDataStore)
    {
        destination.selectedRoutePoint = source.pointToSave
    }
}
