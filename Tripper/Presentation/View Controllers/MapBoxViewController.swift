//
//  MapBoxViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 21.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

fileprivate enum MapViewStatus {
    // First launch/New route creation
    case start
    // Stage of pins setting
    case pinning
    // Stage of route creation, waiting for API response.
    case routing
    // Stage of route's mapping
    case routeMapping
}

protocol MapRouteDelegate: class {
    func mapRoute(performEditFor routePoint: RoutePoint)
    func mapRoute(didDeleted routePoint: RoutePoint)
}

protocol RoutePointEditDelegate: class {
    func route(pointEdited routePoint: RoutePoint)
}

class MapBoxViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var routeLengthView: UIView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var createRouteButton: UIButton!
    @IBOutlet weak var clearAllItem: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    var route: RouteDataModel!
    private var status = MapViewStatus.start
    private var annotationsID: Dictionary<MGLPointAnnotation, String> = Dictionary()
    var directionsRoute: Route?
    
//    var modalTransitioningDelegate: ModalTransitioningDelegate?

    struct SeguesIdentifiers {
        /** You should assign RoutePoint object as sender to this segue. */
        static let showAnnotationDetail = "ShowAnnotationDetail"
        static let showRoute = "ShowRoute"
        /** You should assign RoutePoint object as sender to this segue. */
        static let showAnnotationEdit = "ShowAnnotationEdit"
    }
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        registerGestureRecognizers()
        
        for routePoint in route.points {
            setAnnotation(at: routePoint)
        }
    }
    
    // MARK: - Initializators
    
    private func registerGestureRecognizers() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleMapLongPress(sender:)))
        
        for recognizer in mapView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longPressGestureRecognizer.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @IBAction func clearAll(_ sender: Any) {
        setUIStatus(.pinning)
        
        route.deleteAll()
        annotationsID.removeAll()
        
        // Clear all button should always be disabled while no annotations are placed.
        mapView.removeAnnotations(mapView.annotations!)
        mapView.removeOverlays(mapView.overlays)
    }
    
    @IBAction func createRoute(_ sender: Any?) {
        for i in 0..<(route.points.count - 1) {
            let identifier = route.points[i].id + route.points[i + 1].id
            let sourceCoord = route.points[i].coordinate
            let destinationCoord = route.points[i + 1].coordinate
            calculateRoute(from: sourceCoord, to: destinationCoord, drawHandler: { route in
                self.drawRoute(route: route!, identifier: identifier)
            })
        }
    }
    
    @IBAction func centerAtUser(_ sender: Any) {
        if let userLocation = mapView.userLocation?.coordinate {
            mapView.setCenter(userLocation, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SeguesIdentifiers.showAnnotationDetail:
            let controller = segue.destination as! UINavigationController
            
            let presentingController = controller.viewControllers[0] as! AnnotationDetailViewController
            presentingController.delegate = self
            presentingController.routePoint = (sender as! RoutePoint)
            
//            modalTransitioningDelegate = ModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
//            presentingController.modalPresentationStyle = .custom
//            presentingController.transitioningDelegate = modalTransitioningDelegate
            
        case SeguesIdentifiers.showAnnotationEdit:
            let presentingController = segue.destination as! AnnotationEditViewController
            
            presentingController.delegate = self
            presentingController.routePoint = (sender as! RoutePoint)
            
        default:
            break
        }
    }
    
    // MARK: - UI
    
    private func setupHUD() {
        createRouteButton.isHidden = true
        routeLengthView.isHidden = true
        clearAllItem.isEnabled = false
    }
    
    private func setupMap() {
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        for routePoint in route.points {
            setAnnotation(at: routePoint)
        }
        
        if route.isProperForRouteCreation() {
            setUIStatus(.routing)
        } else {
            setUIStatus(.pinning)
        }
    }
    
    private func setUIStatus(_ newStatus: MapViewStatus) {
        status = newStatus
        configureUIAppearance()
    }
    
    private func configureUIAppearance() {
        let animationDuration = 0.3
        
        switch status {
        case .start:
            UIView.animate(withDuration: animationDuration, animations: {
                self.createRouteButton.isHidden = true
                self.routeLengthView.isHidden = true
                self.clearAllItem.isEnabled = false
            })
        case .pinning:
            UIView.animate(withDuration: animationDuration, animations: {
                self.createRouteButton.isHidden = false
                self.clearAllItem.isEnabled = true
            })
        case .routing:
            createRoute(nil)
            // TODO: Show isLoading view.
            break
        case .routeMapping:
            routeLengthView.isHidden = false
            clearAllItem.isEnabled = true
        }
    }


}

extension MapBoxViewController: MGLMapViewDelegate {
    // MARK: - Map View's Delegates

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let id = annotationsID[annotation as! MGLPointAnnotation]!
        let selectedRoutePoint = route.findRoutePointBy(id: id)
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: selectedRoutePoint)
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        print("*** Deselected annotation")
    }
    
    // MARK: - Actions
    
    @objc @IBAction func handleMapLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        let longPressedPoint: CGPoint = sender.location(in: mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convert(longPressedPoint, toCoordinateFrom: mapView)
        
        print("*** Long pressed point on the map.")
        
        let newRoutePoint = route.createRoutePointWithoutAppending()
        newRoutePoint.coordinate = coordinate
        route.add(point: newRoutePoint)
        setAnnotation(at: newRoutePoint)
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: newRoutePoint)
    }
    
    // MARK: - Helper Methods
    
    private func setAnnotation(at routePoint: RoutePoint) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = routePoint.coordinate
        annotationsID[annotation] = routePoint.id
        mapView.addAnnotation(annotation)
    }
    
    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (Route?) -> Void) {
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let sourceWaypoint = Waypoint(coordinate: source, coordinateAccuracy: -1, name: "Start")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [sourceWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(options, completionHandler: { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            
            drawHandler(self.directionsRoute)
        })
    }
    
    private func drawRoute(route: Route, identifier: String) {
        guard let shape = route.shape, shape.coordinates.count > 0 else { return }
        
        let routeCoordinates = shape.coordinates
        let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: UInt(routeCoordinates.count))
        
        let source = MGLShapeSource(identifier: identifier, features: [polyline], options: nil)
        
        // Customize the route line color and width
        let lineStyle = MGLLineStyleLayer(identifier: identifier, source: source)
        lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        lineStyle.lineWidth = NSExpression(forConstantValue: 3)
        
        mapView.style?.addSource(source)
        mapView.style?.addLayer(lineStyle)
    }
}

extension MapBoxViewController: MapRouteDelegate {
    // MARK: - Map Route Delegate
    
    func mapRoute(performEditFor routePoint: RoutePoint) {
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationEdit, sender: routePoint)
    }
    
    func mapRoute(didDeleted routePoint: RoutePoint) {
        route.delete(routePoint: routePoint)
    }
}

extension MapBoxViewController: RoutePointEditDelegate {
    // MARK: - Route's Point Edit Delegate
    
    func route(pointEdited routePoint: RoutePoint) {
        route.update(routePoint: routePoint)
        print("*** Did edited: \(routePoint)")
    }
}
