//
//  ManageRouteMapInteractor.swift
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

protocol ManageRouteMapBusinessLogic {
    func fetchNewAnnotationsInfo(request: ManageRouteMap.FetchNewAnnotationsInfo.Request)
    func createRoutePoint(request: ManageRouteMap.CreateRoutePoint.Request)
    func setRoutePoint(request: ManageRouteMap.SetRoutePoint.Request)
//    func deselectAnnotation(request)
}

protocol ManageRouteMapDataStore {
    var tappedCoordinate: CLLocationCoordinate2D? { get set }
    var selectedRoutePoint: RoutePoint? { get set }
}

class ManageRouteMapInteractor: ManageRouteMapBusinessLogic, ManageRouteMapDataStore {
    var presenter: ManageRouteMapPresentationLogic?
    var worker: ManageRouteMapWorker?
    
//    var idGenerator: IDGenerator
    
    var annotationsInfo: [AnnotationInfo]
    var idOfSelectedAnnotation: String?
    
    var selectedRoutePoint: RoutePoint? {
        get {
            if let id = idOfSelectedAnnotation {
                let selectedAnnotation = annotationsInfo.first(where: {
                    return $0.id == id
                })
                
                return selectedAnnotation as? RoutePoint
            } else {
                return nil
            }
        }
        
        set {
            idOfSelectedAnnotation = newValue?.id
        }
    }
    
    init() {
        annotationsInfo = []
//        idGenerator = NSUUIDGenerator.instance
    }
    
    // MARK: Create route point
    
    var tappedCoordinate: CLLocationCoordinate2D?
    
    func createRoutePoint(request: ManageRouteMap.CreateRoutePoint.Request) {
        // If new point is creating there is no selected point.
        // TODO: Should extract this logic to separate use case.
        idOfSelectedAnnotation = nil
        
        tappedCoordinate = CLLocationCoordinate2D(latitude: request.latitude, longitude: request.longitude)
//        let id = idGenerator.generate()
        let response = ManageRouteMap.CreateRoutePoint.Response()
        presenter?.presentAnnotationCreation(response: response)
    }
    
    // MARK: Fetch new annotations info
    
    func fetchNewAnnotationsInfo(request: ManageRouteMap.FetchNewAnnotationsInfo.Request) {
        let annotationsInfo = worker?.fetchNewAnnotationsInfo() ?? []
        let response = ManageRouteMap.FetchNewAnnotationsInfo.Response(annotationsInfo: annotationsInfo)
        
        presenter?.presentFetchNewAnnotationsInfo(response: response)
    }
    
    func setRoutePoint(request: ManageRouteMap.SetRoutePoint.Request) {
//        let response = ManageRouteMap.SetRoutePoint.Response(annotationInfo: request)
//        presenter?.presentSetRoutePoint(response: ManageRouteMap.SetRoutePoint.Response)
    }
}
