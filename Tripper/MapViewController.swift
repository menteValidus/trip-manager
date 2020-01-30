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
    
    
    // MARK:- View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(region(for: routePoints), animated: true)
    }
    
    // MARK:- Actions
    
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
        mapView.removeOverlays(mapView.overlays)
        routePoints.removeAll()
        currentRouteNumber = 1
    }
    
    @IBAction func createRoute(_ sender: UIButton) {
        if routePoints.count > 0 {
            var sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
            layoutRoute(from: sourceMapItem, to: routePoints[0].mapItem)
            
            for routePoint in routePoints {
                layoutRoute(from: sourceMapItem, to: routePoint.mapItem)
                sourceMapItem = routePoint.mapItem
            }
        }
        var routes = routePoints
        routes.append(RoutePoint(coordinate: mapView.userLocation.coordinate))
        
        mapView.setRegion(region(for: routePoints), animated: true)
        print("*** Route created.")
    }
    
    // MARK: - Helper methods
    
    private func layoutRoute(from source: MKMapItem, to destination: MKMapItem) {
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = source
        directionsRequest.destination = destination
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
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
//            region
        })
    }
    
    func region(for routePoints: [RoutePoint]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch routePoints.count {
        case 0:
            region = MKCoordinateRegion( center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        case 1:
            let point = routePoints[routePoints.count - 1]
            region = MKCoordinateRegion(center: point.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for points in routePoints {
                topLeft.latitude = max(topLeft.latitude, points.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, points.coordinate.longitude)
                bottomRight.latitude = min(bottomRight.latitude, points.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, points.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2, longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
            
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace, longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MapView Delegates
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
