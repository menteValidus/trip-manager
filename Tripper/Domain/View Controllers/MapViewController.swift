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

protocol MapRouteDelegate: class {
    func mapRoute(didChanged routePoint: RoutePoint)
    func mapRoute(didDeleted routePoint: RoutePoint)
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var routeLengthView: UIView!
    @IBOutlet weak var createRouteButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var currentRouteNumber = 1
    
    var route: RouteDataModel!
    var overlays = [MKOverlay]()
    private var annotations = [RoutePointAnnotation]()
    private var wholeRouteLength = 0.0
    
    private var selectedAnnotation: RoutePointAnnotation?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    struct SeguesIdentifiers {
        static let showRouteList = "ShowRouteList"
        static let showAnnotationDetail = "ShowAnnotationDetail"
    }
    
    // MARK:- View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentRouteNumber = route.points.count + 1
        
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
        let newPoint = RoutePoint(coordinate: locationCoord)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoord
        annotation.title = "Route point #\(currentRouteNumber)"
        currentRouteNumber += 1
        
        route.add(point: newPoint)
//        annotations.append(annotation)
        
        mapView.addAnnotation(annotation)
        
        let annotationRegion = region(for: [RoutePoint(from: annotation)])
        mapView.setRegion(annotationRegion, animated: true)
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: newPoint)
    }

    @IBAction func cancelRouteCreation(_ sender: UIBarButtonItem) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        route.deleteAll()
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
            controller.subroutes = route.subroutes
        }
        
        if segue.identifier == SeguesIdentifiers.showAnnotationDetail {
            let controller = segue.destination as! AnnotationDetailViewController
            
            controller.routePoint = (sender as! RoutePoint)
            controller.delegate = self
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
                    // The most frequent error is error of creatig route in the country that is different from user's country.
                    // That's why this error is commented. In future we have to deal with this problem.
                    //throwAn(error: error)
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
        overlays.append(route.polyline)

        // This statement determines whether the end of route creation or not.
        if overlays.count == self.route.points.count {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func restoreLayout() {
        if route.points.count > 1 {
            let secondToLastIndex = (route.points.count - 1) - 1
            for i in 0...secondToLastIndex {
                calculateAndLayoutRoute(from: route.points[i].mapItem, to: route.points[i + 1].mapItem)
                setPin(at: route.points[i])
            }
        }
        
        setPin(at: route.points.last!)
    }
    
    private func setPin(at routePoint: RoutePoint) {
        let annotation = createAnnotation(from: routePoint)
//        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    private func createAnnotation(from routePoint: RoutePoint) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = routePoint.title
        annotation.coordinate = routePoint.coordinate
        return annotation
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let identifier = "Staying"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
          let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          pinView.isEnabled = true
          pinView.canShowCallout = true
          pinView.animatesDrop = false
          pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
          let rightButton = UIButton(type: .detailDisclosure)
          rightButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
          pinView.rightCalloutAccessoryView = rightButton
          annotationView = pinView
        }
        if let annotationView = annotationView {
          annotationView.annotation = annotation
          let button = annotationView.rightCalloutAccessoryView as! UIButton
          if let index = findID(of: annotation) {
            button.tag = index
          }
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        selectedAnnotation = view.annotation
        print("*** Selected.")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedAnnotation = nil
        print("*** Deselected.")
    }
    
    // MARK: - Helper Methods
    
    @objc func showDetails(_ sender: UIButton) {
        let annotationRegion = region(for: [RoutePoint(from: selectedAnnotation!)])
        mapView.setRegion(annotationRegion, animated: true)
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: route.points[sender.tag])
    }
    
    
    
    func findID(of annotation: MKAnnotation) -> Int? {
        for index in 0..<annotations.count {
            if annotations[index].isEqual(annotation) {
                return index
            }
        }
        
        return nil
    }
    
}

extension MapViewController: MapRouteDelegate {
    // MARK: - Map Routes Delegates
    
    func mapRoute(didChanged routePoint: RoutePoint) {
        route.update(routePoint: routePoint)
        if let annotation = selectedAnnotation {
            mapView.removeAnnotation(annotation)
            mapView.addAnnotation(createAnnotation(from: routePoint))
        }
    }
    
    func mapRoute(didDeleted routePoint: RoutePoint) {
        route.delete(routePoint: routePoint)
        if let annotation = selectedAnnotation {
            mapView.removeAnnotation(annotation)
            selectedAnnotation = nil
        }
    }
}