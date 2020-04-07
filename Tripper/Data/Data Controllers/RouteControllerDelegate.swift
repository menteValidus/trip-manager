//
//  RouteControllerDelegate.swift
//  Tripper
//
//  Created by Denis Cherniy on 12.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation

protocol RouteControllerDelegate {
    func routeController(didDeleted routePoint: RoutePointVM)
    func routeController(didCalculated routeFragment: RouteFragment)
    func routeController(identifierOfDeletedRouteFragment: String)
    func routeControllerCleared()
    func routeControllerDidUpdated()
    func routeControllerIsStartedRouting()
    func routeControllerIsFinishedRouting()
    func routeControllerError(with routePoint: RoutePointVM)
}
