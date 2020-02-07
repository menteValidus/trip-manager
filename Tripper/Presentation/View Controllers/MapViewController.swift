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
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var routeLengthView: UIView!
    @IBOutlet weak var createRouteButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var currentRouteNumber = 1
    
    var route: RouteDataModel!
    var wholeRouteLength = 0.0
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    struct SeguesIdentifiers {
        static let showRouteList = "ShowRouteList"
        static let showAnnotationDetail = "ShowAnnotationDetail"
    }
    
    // MARK:- View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !route.points.isEmpty {
            restoreLayout()
        }
        
        routeLengthView.isHidden = true
        routeLengthView.layer.cornerRadius = 8
        createRouteButton.isHidden = true
    }
    
    // MARK:- Actions
    
    @IBAction func showUser() {
        requestAccess()
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func setPin(_ sender: UILongPressGestureRecognizer) {
        
        if createRouteButton.isHidden == true {
            createRouteButton.isHidden = false
        }
        
        if sender.state != .began {
            return
        }
        
        let location = sender.location(in: mapView)
        let locationCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoord
        annotation.title = "Route point #\(currentRouteNumber)"
        currentRouteNumber += 1
        
        route.add(point: RoutePoint(from: annotation))
        
        mapView.addAnnotation(annotation)
    }

    @IBAction func cancelRouteCreation(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "ShowAnnotationDetail", sender: sender)
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        route.clear()
        currentRouteNumber = 1
        
        hideUI()
        showUser()
    }
    
    @IBAction func createRoute(_ sender: UIButton) {
        createRoute()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.showRouteList {
            let controller = segue.destination as! RouteListViewController
            controller.route = route
        }
        
        if segue.identifier == SeguesIdentifiers.showAnnotationDetail {
            let controller = segue.destination as! AnnotationDetailViewController
            controller.routePoint = route.points[(sender as! IndexPath).row]
            slideInTransitioningDelegate.direction = .bottom
            controller.transitioningDelegate = slideInTransitioningDelegate
            controller.modalPresentationStyle = .custom
        }
    }
    
    // MARK: - Helper methods
    
    private func requestAccess() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
        // MARK: Route Creation
    
    private func createRoute() {
        if route.points.count > 1 {
            let secondToLastIndex = (route.points.count - 1) - 1
            for i in 0...secondToLastIndex {
                calculateAndLayoutRoute(from: route.points[i].mapItem, to: route.points[i + 1].mapItem)
            }
        }
        
        centerAtRoute()
        print("*** Route created.")
    }
    
    private func calculateAndLayoutRoute(from source: MKMapItem, to destination: MKMapItem) {
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
            self.wholeRouteLength += route.distance
            
            self.layout(route: route)
        })
    }
    
    private func layout(route: MKRoute) {
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        self.route.overlays.append(route.polyline)

        // This statement determines whether the end of route creation or not.
        if self.route.overlays.count == self.route.points.count {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func restoreLayout() {
        let secondToLastIndex = (route.points.count - 1) - 1
        for i in 0...secondToLastIndex {
            calculateAndLayoutRoute(from: route.points[i].mapItem, to: route.points[i + 1].mapItem)
            setPin(at: route.points[i])
        }
        
        setPin(at: route.points.last!)
    }
    
    private func setPin(at routePoint: RoutePoint) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = routePoint.coordinate
        // TODO: set title and description
        mapView.addAnnotation(annotation)
    }
    
        // MARK: Map Zooming
    
    private func centerAtRoute() {
        mapView.setRegion(region(for: route.points), animated: true)
    }

    private func region(for routePoints: [RoutePoint]) -> MKCoordinateRegion {
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

        // MARK: UI Methods
    
    private func updateUI() {
        let length = Int(wholeRouteLength)
        routeLengthLabel.text = format(routeLength: length)
        if routeLengthView.isHidden == true {
            routeLengthView.isHidden = false
        }
    }
    
    private func hideUI() {
        routeLengthView.isHidden = true
        createRouteButton.isHidden = true
    }
    
    private func format(routeLength: Int) -> String {
        if routeLength > 999 {
            return String(format: "%i km", routeLength / 1000)
        } else {
            return String(format: "%i m", routeLength)
        }
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
