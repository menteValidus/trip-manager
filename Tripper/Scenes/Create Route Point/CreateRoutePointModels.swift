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
    
    enum AnnotationEditState {
        case normal
        case arrivalDateEditing
        case departureDateEditing
    }
    
    // MARK: Use cases
    
    enum FormRoutePoint {
        struct Request {
        }
        struct Response {
            let navigationTitle: String
            let routePoint: RoutePoint
        }
        struct ViewModel {
            let navigationTitle: String
            let annotationForm: DisplayableAnnotationInfo
        }
    }
    
    enum SaveRoutePoint {
        struct Request {
            let title: String
            let description: String
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
    
    enum SetDate {
        struct Request {
            let newDate: Date
        }
        struct Response {
            let newDate: Date
            let state: AnnotationEditState
        }
        struct ViewModel {
            let date: Date
            let dateString: String
            let state: AnnotationEditState
        }
    }
    
    enum ToggleDateEditState {
        struct Request {
            let section: Int
            let row: Int
        }
        struct Response {
            let oldState: AnnotationEditState
            let newState: AnnotationEditState
        }
        struct ViewModel {
            let oldState: AnnotationEditState
            let newState: AnnotationEditState
        }
    }
    
    enum ShowDatePicker {
        struct Request {
            let state: AnnotationEditState
        }
        struct Response {
            let state: AnnotationEditState
            let date: Date
        }
        struct ViewModel {
            let state: AnnotationEditState
            let date: Date
        }
    }
    
    enum HideDatePicker {
        struct Request {
            let state: AnnotationEditState
        }
        struct Response {
            let state: AnnotationEditState
        }
        struct ViewModel {
            let state: AnnotationEditState
        }
    }
}
