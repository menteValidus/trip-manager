//
//  MapViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var currentRouteNumber = 1
    
    var routePoints = [RoutePoint]()
    
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUser()
    }
    
    // MARK: - Actions
    
    @IBAction func showUser() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func setPin(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        
        let location = sender.location(in: mapView)
        let locationCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoord
        annotation.title = "Route point #\(currentRouteNumber)"
        currentRouteNumber += 1
        
        routePoints.append(RoutePoint(from: annotation))
        
        mapView.addAnnotation(annotation)
    }

    @IBAction func cancelRouteCreation(_ sender: UIBarButtonItem) {
        mapView.removeAnnotations(mapView.annotations)
        routePoints.removeAll()
        currentRouteNumber = 1
    }
    
    @IBAction func createRoute(_ sender: UIButton) {
        if routePoints.count > 1 {
            let directionsRequest = MKDirections.Request()
            
            directionsRequest.source = routePoints[0].mapItem
            directionsRequest.destination = routePoints[1].mapItem
            directionsRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionsRequest)
            directions.calculate(completionHandler: { response, error in
                guard let directionResponse = response else {
                    if let error = error {
                        throwAn(error: error)
                    }
                    
                    return
                }
                
                let route = directionResponse.routes[0]
                
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            })
        }
        
        print("*** Route created.")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
