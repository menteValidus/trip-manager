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
    @IBOutlet weak var routeEstimationView: UIView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var routeTimeLabel: UILabel!
    @IBOutlet weak var clearAllItem: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    private var lineSources = [MGLShapeSource]()
    private var lineStyles = [MGLLineStyleLayer]()
    
    var route: RouteController!
    private var status = MapViewStatus.start
    private var annotationsID: Dictionary<MGLPointAnnotation, String> = Dictionary()
    
    private var detailsTransitioningDelegate: RoutePointDetailsModalTransitioningDelegate!
    
    private lazy var dimmingView = { () -> UIView in
        let dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = dimmingView.bounds
        dimmingView.addSubview(blurEffectView)
        
        return dimmingView
    }()

    struct SeguesIdentifiers {
        /** You should assign RoutePoint object as sender to this segue. */
        static let showAnnotationDetail = "ShowAnnotationDetail"
        static let showRoute = "ShowRoute"
        /** You should assign RoutePoint object as sender to this segue. */
        static let showAnnotationEdit = "ShowAnnotationEdit"
        static let showRouteList = "ShowRouteList"
    }
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        route = RouteController(delegate: self)
        
        routeEstimationView.layer.cornerRadius = 16
        
        initMap()
        registerGestureRecognizers()
        
        route.routeControllerDelegate = self
        
        if route.isProperForRouteCreation {
            setUIStatus(.routing)
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
    
    private func initMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        for routePoint in route.points {
            setAnnotation(at: routePoint)
        }
        
        if route.points.count != 0 {
            centerAt(location: route.points[0].coordinate)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clearAll(_ sender: Any) {
        route.deleteAll()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SeguesIdentifiers.showAnnotationDetail:
            let presentingController = segue.destination as! AnnotationDetailViewController
            presentingController.delegate = self
            presentingController.routePoint = (sender as! RoutePoint)
            
            detailsTransitioningDelegate = RoutePointDetailsModalTransitioningDelegate(from: self, to: presentingController)
            presentingController.modalPresentationStyle = .custom
            presentingController.transitioningDelegate = detailsTransitioningDelegate
            
            
        case SeguesIdentifiers.showAnnotationEdit:
            let presentingController = segue.destination as! AnnotationEditViewController
            
            presentingController.delegate = self
            presentingController.routePoint = (sender as! RoutePoint)
            
        case SeguesIdentifiers.showRouteList:
            let presentingController = segue.destination as! RouteListViewController
            
            presentingController.subroutes = route.subroutes
            
        default:
            break
        }
    }
    
    private func showDetail(of routePoint: RoutePoint) {
        let height = view.frame.height
        let width  = view.frame.width
        let bottomOffset = UIApplication.shared.statusBarFrame.height + 15
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? AnnotationDetailViewController else { return }
        
        detailVC.routePoint = routePoint
        
        self.addChild(detailVC)
        self.view.addSubview(detailVC.view)
        detailVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
        detailVC.didMove(toParent: self)
        
        let yCoordinate = view.frame.height * 0.75
        UIView.animate(withDuration: 0.3) {
            detailVC.view.frame = CGRect(x: 0, y: yCoordinate, width: width, height: yCoordinate + bottomOffset)
        }
        
        detailVC.delegate = self
    }
    
    // MARK: - UI

    private func setUIStatus(_ newStatus: MapViewStatus) {
        status = newStatus
        configureUIAppearance()
    }
    
    private func configureUIAppearance() {
        
        switch status {
        case .start:
            self.routeEstimationView.isHidden = true
            self.clearAllItem.isEnabled = false
            
        case .pinning:
            self.clearAllItem.isEnabled = true
            
        case .routing:
            showSpinner()
            
        case .routeMapping:
            hideSpinner()
            
            routeEstimationView.isHidden = false
            let timeInMin = route.totalTimeInMinutes
            let length = route.totalLengthInMeters
            
            let lengthText = length < 1000 ? "\(length) m" : "\(length / 1000) km \(length % 1000) m"
            routeLengthLabel.text = lengthText
            
            let timeText = timeInMin < 60 ? "\(timeInMin) min" : "\(timeInMin / 60) h \(timeInMin % 60) min"
            routeTimeLabel.text = timeText
            
        }
    }

    private func showSpinner() {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.center = CGPoint(x: dimmingView.bounds.midX + 0.5, y: dimmingView.bounds.midY + 0.5)
        spinner.tag = 1000
        dimmingView.addSubview(spinner)
        
        
        view.addSubview(dimmingView)
        spinner.startAnimating()
    }
    
    private func hideSpinner() {
        dimmingView.removeFromSuperview()
    }

}

extension MapBoxViewController: MGLMapViewDelegate {
    // MARK: - Map View's Delegates

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("*** Selected annotation")
        let id = annotationsID[annotation as! MGLPointAnnotation]!
        let selectedRoutePoint = route.findRoutePointBy(id: id)
        showDetail(of: selectedRoutePoint!)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        print("*** Deselected annotation")
    }
    
    // MARK: - Actions
    
    @objc func handleMapLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        
        let longPressedPoint: CGPoint = sender.location(in: mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convert(longPressedPoint, toCoordinateFrom: mapView)
        
        print("*** Long pressed on the map.")
        
        let newRoutePoint = route.createNextRoutePoint(at: coordinate)
        if route.isProperForRouteCreation {
            setUIStatus(.routing)
        }
        
        setAnnotation(at: newRoutePoint)
    }
    
    // MARK: - Helper Methods
    
    private func setAnnotation(at routePoint: RoutePoint) {
        let annotation = MGLPointAnnotation()
        annotation.title = routePoint.title
        annotation.subtitle = routePoint.subtitle
        annotation.coordinate = routePoint.coordinate
        annotationsID[annotation] = routePoint.id
        mapView.addAnnotation(annotation)
    }
    
    private func centerAt(location coordinate: CLLocationCoordinate2D, at zoomLevel: Double = 5.0) {
        mapView.setCenter(coordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    private func setMapCameraAt(coordinates: [CLLocationCoordinate2D]) {
        switch coordinates.count {
        case 0:
            return
            
        case 1:
            mapView.setCenter(coordinates[0], animated: true)
            break
            
        default: // > 1
            // TODO: Implement
            //mapView.cameraThatFitsCoordinateBounds(MGLCoordinateBounds(sw: , ne: ), edgePadding: )
            break
        }
    }
    
    private func setMapCameraAt(shape: MGLShape) {
        // TODO: Implement
    }
}

extension MapBoxViewController: MapRouteDelegate {
    // MARK: - Map Route Delegate
    
    func mapRoute(performEditFor routePoint: RoutePoint) {
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationEdit, sender: routePoint)
    }
    
    func mapRoute(didDeleted routePoint: RoutePoint) {
        for (annotation, id) in annotationsID {
            if id == routePoint.id {
                mapView.removeAnnotation(annotation)
            }
        }
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

extension MapBoxViewController: RouteControllerDelegate {
    // MARK: - Route Controller's Delegate
    
    func routeController(didCalculated routeFragment: RouteFragment) {
        drawRoute(routeCoordinates: routeFragment.coordinates, identifier: routeFragment.identifier)
    }
    
    func routeController(identifierOfDeletedRouteFragment: String) {
        if let sources = mapView.style?.sources {
            for source in sources {
                if source.identifier == identifierOfDeletedRouteFragment {
                    mapView.style!.removeSource(source)
                }
            }
        }
        
        if let layer = mapView.style?.layer(withIdentifier: identifierOfDeletedRouteFragment) {
            mapView.style!.removeLayer(layer)
        }
        
    }
    
    func routeControllerCleared() {
        annotationsID.removeAll()
        
        // Clear all button should always be disabled while no annotations are placed.
        if let annotations = mapView.annotations {
            for annotation in annotations {
                mapView.removeAnnotation(annotation)
            }
        }
        
        for source in lineSources {
            mapView.style?.removeSource(source)
        }
        
        for style in lineStyles {
            mapView.style?.removeLayer(style)
        }
        
    }
    
    func routeControllerIsStartedRouting() {
        if status != .routing {
            setUIStatus(.routing)
        }
    }
    
    func routeControllerIsFinishedRouting() {
        setUIStatus(.routeMapping)
    }
    
    // MARK: - Helper Methods
    
    private func drawRoute(routeCoordinates: [CLLocationCoordinate2D], identifier: String) {
        guard routeCoordinates.count > 0 else { return }
        
        let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: UInt(routeCoordinates.count))
        
        let source = MGLShapeSource(identifier: identifier, features: [polyline], options: nil)
        
        // Customize the route line color and width
        let lineStyle = MGLLineStyleLayer(identifier: identifier, source: source)
        lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        lineStyle.lineWidth = NSExpression(forConstantValue: 3)
        
        mapView.style?.addSource(source)
        lineSources.append(source)
        mapView.style?.addLayer(lineStyle)
        lineStyles.append(lineStyle)
    }
}
