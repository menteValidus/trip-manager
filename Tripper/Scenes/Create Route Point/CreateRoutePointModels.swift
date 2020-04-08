//
//  CreateRoutePointModels.swift
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

enum CreateRoutePoint {
    struct DisplayableAnnotationInfo {
        var title: String
        var subtitle: String
        var arrivalDate: String
        var departureDate: String
    }
    
    // MARK: Use cases
    
    enum FormRoutePoint {
        struct Request {
        }
        struct Response {
            let routePoint: RoutePoint
        }
        struct ViewModel {
            let annotationForm: DisplayableAnnotationInfo
        }
    }
    
    enum SaveRoutePoint {
        struct Request {
            let title: String
            let description: String
            let arrivalDate: Date
            let departureDate: Date
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum CancelCreation {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
