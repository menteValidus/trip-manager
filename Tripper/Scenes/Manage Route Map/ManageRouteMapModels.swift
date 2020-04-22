//
//  ManageRouteMapModels.swift
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
import CoreLocation

protocol RouteFragment {
    var identifier: String { get set }
    var coordinates: [CLLocationCoordinate2D] { get set }
    var travelTimeInSeconds: Int { get set }
    var travelDistanceInMeters: Int { get set }
}

enum ManageRouteMap {
    
    struct ConcreteAnnotationInfo: AnnotationInfo {
        let id: String
        let orderNumber: Int
        let latitude: Double
        let longitude: Double
    }
    
    struct ConcreteRouteFragment: RouteFragment {
        var identifier: String
        var coordinates: [CLLocationCoordinate2D]
        var travelTimeInSeconds: Int
        var travelDistanceInMeters: Int
    }
    
    // MARK: Use cases
    
    enum FetchDifference {
        struct Request {
        }
        struct Response {
            let newAnnotationsInfo: [AnnotationInfo]
            let removedAnnotationInfo: [AnnotationInfo]
        }
        struct ViewModel {
            let newAnnotationsInfo: [AnnotationInfo]
            let removedAnnotationsInfo: [AnnotationInfo]
        }
    }
    
    enum CreateRoutePoint {
        struct Request {
            let latitude: Double
            let longitude: Double
        }
        struct Response {
            let isSucceed: Bool
        }
        struct ViewModel {
            let isSucceed: Bool
        }
    }
    
    enum SetRoutePoint {
        struct Request {
            let annotationsInfo: AnnotationInfo
        }
        struct Response {
            let annotationInfo: AnnotationInfo
        }
        struct ViewModel {
            let annotationInfo: AnnotationInfo
        }
    }
    
    enum SelectAnnotation {
        struct Request {
            let identifier: String?
        }
        struct Response {
            let identifier: String?
        }
        struct ViewModel {
            let identifier: String?
        }
    }
    
    enum DeselectAnnotation {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum ShowDetail {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    
    enum EditRoutePoint {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum DeleteAnnotation {
        struct Request {
            let identifier: String
        }
        struct Response {
            let identifier: String?
        }
        struct ViewModel {
            let identifier: String?
        }
    }
    
    enum CreateRouteFragment {
        struct Request {
            let addedSubrouteInfo: MapRoute.SubrouteInfo
        }
        struct Response {
            let routeFragment: ConcreteRouteFragment
        }
        struct ViewModel {
            let routeFragment: ConcreteRouteFragment
        }
    }
    
    enum DeleteRouteFragment {
        struct Request {
            let identifier: String
        }
        struct Response {
            let identifier: String
        }
        struct ViewModel {
            let identifier: String
        }
    }
    
    enum MapRoute {
        struct SubrouteInfo {
            let startWaypoint: Waypoint
            let endWaypoint: Waypoint
        }
        
        struct Waypoint {
            let id: String
            let latitude: Double
            let longitude: Double
        }
        
        struct Request {
            let addedAnnotationsInfo: [AnnotationInfo]
            let removedAnnotationsInfo: [AnnotationInfo]
        }
        struct Response {
            let addedSubroutesInfo: [SubrouteInfo]
            let idsOfDeletedRouteFragments: [String]
        }
        struct ViewModel {
            let addedSubroutesInfo: [SubrouteInfo]
            let idsOfDeletedRouteFragments: [String]
        }
    }
    
    enum ClearAll {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum ToggleUserInput {
        struct Request {
            let isLocked: Bool
        }
        struct Response {
            let isLocked: Bool
        }
        struct ViewModel {
            let isLocked: Bool
        }
    }
    
    enum FocusOnRoute {
        struct Request {
        }
        struct Response {
            let southWestCoordinate: CLLocationCoordinate2D
            let northEastCoordinate: CLLocationCoordinate2D
        }
        struct ViewModel {
            let southWestCoordinate: CLLocationCoordinate2D
            let northEastCoordinate: CLLocationCoordinate2D
        }
    }
    
    enum FocusOnUser {
        struct Request {
            let userCoordinate: CLLocationCoordinate2D
        }
        struct Response {
            let userCoordinate: CLLocationCoordinate2D
        }
        struct ViewModel {
            let userCoordinate: CLLocationCoordinate2D
        }
    }
    
    enum RouteEstimation {
        struct Request {
        }
        struct Response {
            let timeInSeconds: Int
            let distanceInMeters: Int
        }
        struct ViewModel {
            let toShow: Bool
            let timeEstimation: String
            let distanceEstimation: String
        }
    }
}
