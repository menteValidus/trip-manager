//
//  CreateRoutePointInteractor.swift
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

protocol CreateRoutePointBusinessLogic {
    func formRoutePoint(request: CreateRoutePoint.FormRoutePoint.Request)
    func saveRoutePoint(request: CreateRoutePoint.SaveRoutePoint.Request)
}

protocol CreateRoutePointDataStore {
    var pointToSave: RoutePoint? { get set }
}

class CreateRoutePointInteractor: CreateRoutePointBusinessLogic, CreateRoutePointDataStore {
    var presenter: CreateRoutePointPresentationLogic?
    var worker: CreateRoutePointWorker?
    var pointToSave: RoutePoint?
    
    // MARK: Form Route Point
    
    func formRoutePoint(request: CreateRoutePoint.FormRoutePoint.Request) {
//        worker = CreateRoutePointWorker()
//        worker?.doSomeWork()
        
//        let annotationInfo = CreateRoutePoint.DisplayableAnnotationInfo(
//            title: pointToEdit?.title, subtitle: pointToEdit?.subtitle,
//            arrivalDate: pointToEdit?.arrivalDate, departureDate: pointToEdit?.departureDate,
//            timeToNextPointInSeconds: pointToEdit?.timeToNextPointInSeconds,
//            distanceToNextPointInMeters: pointToEdit?.distanceToNextPointInMeters)
        if pointToSave == nil {
            pointToSave = createNewRoutePoint()
        }
        
        let response = CreateRoutePoint.FormRoutePoint.Response(routePoint: pointToSave!)
        presenter?.presentFormRoutePoint(response: response)
    }
    
    func saveRoutePoint(request: CreateRoutePoint.SaveRoutePoint.Request) {
        if pointToSave != nil {
            pointToSave?.title = request.title
            pointToSave?.subtitle = request.description
            pointToSave?.arrivalDate = request.arrivalDate
            pointToSave?.departureDate = request.departureDate
            
            worker?.save(routePoint: pointToSave!)
            
            let response = CreateRoutePoint.SaveRoutePoint.Response()
            presenter?.presentSaveRoutePoint(response: response)
        } else {
            fatalError("*** There's no way we can be here!")
        }
    }
    
    // MARK: - Helper Methods
    
    private func createNewRoutePoint() -> RoutePoint {
        let routePoint = RoutePoint(id: "test_id", orderNumber: 0)
        return routePoint
    }
}
