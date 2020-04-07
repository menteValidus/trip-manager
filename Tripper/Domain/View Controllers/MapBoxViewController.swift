//
//  MapBoxViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 21.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//
/**
 Начать с данного ViewController'a .
 - Часть помеченных методов адаптировать и вынести в Interactor и Presenter.
 - Использовать два Worker'a . Первый - для обертки SharedCoreDataWorker,  второй - для взаимодействия с Mapbox Directions API.
 - При взаимодействии с  ShowDetailScene  использовать делегат, хранимый в Interactor'e  сцены.
 */

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

fileprivate enum MapViewStatus {
    /// First launch/New route creation
    case start
    /// Stage of route creation, waiting for API response.
    case routing
    /// Stage of route's mapping
    case routeMapping
}

protocol MapRouteDelegate: class {
    func mapRoute(performEditFor routePoint: RoutePoint)
    func mapRoute(didDeleted routePoint: RoutePoint)
}

protocol RoutePointEditDelegate: class {
    func route(pointEdited routePoint: RoutePoint)
    func route(pointCreated routePoint: RoutePoint)
    func routePointCreationDidCancelled()
}

class MapBoxViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var routeEstimationView: UIView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var routeTimeLabel: UILabel!
    @IBOutlet weak var clearAllBarItem: UIBarButtonItem!
    @IBOutlet weak var routeListBarItem: UIBarButtonItem!
    
    // TODO: MOVE TO INTERACTOR.
    private var locationManager = CLLocationManager()
    
    private var lineSources = [MGLShapeSource]()
    private var lineStyles = [MGLLineStyleLayer]()
    
    // TODO: MOVE TO WORKER. WILL BE INSTANTIATED IN INTERACTOR
    private var routeController: RouteController!
    // TODO: REMOVE
    private var status: MapViewStatus!
    private var annotationsID: Dictionary<MGLPointAnnotation, String> = Dictionary()
    private var newCreatedRP: RoutePoint? = nil
    
    // TODO: REMOVE
    private var detailViewController: AnnotationDetailViewController? = nil
    
    private lazy var dimmingView = { () -> UIView in
        let dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = dimmingView.bounds
        dimmingView.addSubview(blurEffectView)
        
        return dimmingView
    }()

    // TODO: REMOVE
    struct SeguesIdentifiers {
        /// You should assign RoutePoint object as sender to this segue.
        static let showAnnotationDetail = "ShowAnnotationDetail"
        /// You should assign RoutePoint object as sender to this segue. 
        static let showAnnotationEdit = "ShowAnnotationEdit"
        static let showRouteList = "ShowRouteList"
    }
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeController = RouteController(delegate: self)
        
        routeEstimationView.layer.cornerRadius = 16
        
        #if DEBUG
        print("*** *** *** DEBUG *** *** ***")
        #endif
        
        initMap()
        registerGestureRecognizers()
        
    }
    
    // MARK: - Initializators
    // TODO: MOVE TO INTERACTOR
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
        
        for routePoint in routeController.points {
            setAnnotation(at: routePoint)
        }
        // TODO: INTERACT WITH ANNOTATIONS INSTEAD OF ROUTEPOINTS
        if routeController.points.count > 0 {
            centerAt(location: routeController.points[0].coordinate)
            if routeController.isProperForRouteCreation {
                setUIStatus(.routing)
            } else {
                setUIStatus(.routeMapping)
            }
        } else {
            setUIStatus(.start)
        }
    }
    
    // MARK: - Actions
    
    // TODO: MOVE INNER LOGIC TO INTERACTOR
    @IBAction func clearAll(_ sender: Any) {
        routeController.deleteAll()
        dismissDetail()
        setUIStatus(.start)
    }
    
    // MARK: - Navigation
    
    // TODO: MOVE IT TO THE ROUTER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case SeguesIdentifiers.showAnnotationEdit:
            let presentingController = segue.destination as! AnnotationEditViewController
            
            presentingController.delegate = self
            if let createdRoutePoint = newCreatedRP {
                let leftDateLimit = routeController.leftLimitOf(createdRoutePoint)
                presentingController.leftDateLimit = leftDateLimit
                presentingController.routePoint = createdRoutePoint
                presentingController.isEdit = false
            } else {
                let routePoint = (sender as! RoutePoint)
                let leftDateLimit = routeController.leftLimitOf(routePoint)
                presentingController.leftDateLimit = leftDateLimit
                let rightDateLimit = routeController.rightLimitOf(routePoint)
                presentingController.rightDateLimit = rightDateLimit
                presentingController.routePoint = routePoint
                presentingController.isEdit = true
            }
            
        case SeguesIdentifiers.showRouteList:
            let presentingController = segue.destination as! RouteListViewController
            
            presentingController.subroutes = routeController.subroutes
            
        default:
            break
        }
    }
    
    // TODO: MOVE IT TO THE SHOW DETAIL SCENE. HEIGHT, WIDTH AND OFFSET SET THROUGH CONSTRUCTOR.
    private func showDetail(of routePoint: RoutePoint) {
        let height = view.frame.height
        let width  = view.frame.width
        let bottomOffset = UIApplication.shared.statusBarFrame.height + 15
        
        if let detailViewController = detailViewController {
            detailViewController.routePoint = routePoint
            detailViewController.configureUI()
        } else {
            guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? AnnotationDetailViewController else { return }
            
            
            detailViewController = detailVC
            if let detailViewController = detailViewController {
                detailViewController.routePoint = routePoint
                
                self.view.addSubview(detailViewController.view)
                detailViewController.view.frame = CGRect(x: 0, y: height, width: width, height: height)
                detailViewController.didMove(toParent: self)
                
                let yCoordinate = view.frame.height * 0.75
                UIView.animate(withDuration: 0.3) {
                    detailViewController.view.frame = CGRect(x: 0, y: yCoordinate, width: width, height: yCoordinate + bottomOffset)
                }
                
                detailViewController.delegate = self
            }
            
        }
        
        
    }
    
    // TODO: MOVE IT TO THE SHOW DETAIL SCENE'S ROUTER.
    private func dismissDetail() {
        if let detailViewController = detailViewController {
            detailViewController.removeFromParent()
            UIView.animate(withDuration: 0.3, animations: {
                detailViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: detailViewController.view.frame.height)
            }, completion: { _ in
                detailViewController.view.removeFromSuperview()
            })
        }
        
        detailViewController = nil
    }
    
    // MARK: - UI
    
    // TODO: COMBINE IT WITH configureUIAppearance AND MOVE EVERYTHING TO PRESENTER.
    private func setUIStatus(_ newStatus: MapViewStatus) {
        status = newStatus
        configureUIAppearance()
    }
    
    private func configureUIAppearance() {
        
        switch status {
        case .start:
            routeEstimationView.isHidden = true
            clearAllBarItem.isEnabled = false
    
        case .routing:
            clearAllBarItem.isEnabled = false
            routeListBarItem.isEnabled = false
            
            showSpinner()
            
        case .routeMapping:
            hideSpinner()
            
            if routeController.isProperForRouteCreation {
                clearAllBarItem.isEnabled = true
                routeListBarItem.isEnabled = true
                
                routeLengthLabel.text = format(metres: routeController.totalLengthInMeters)
                routeTimeLabel.text = format(seconds: routeController.totalTimeInSeconds)
                
                showEstimationView()
            } else {
                clearAllBarItem.isEnabled = true
                hideEstimationView()
            }
            
            
        case .none:
            return
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
    
    private func showEstimationView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.routeEstimationView.alpha = 1
            self.routeEstimationView.isHidden = false
        })
    }
    
    private func hideEstimationView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.routeEstimationView.alpha = 0
            self.routeEstimationView.isHidden = true
        })
    }

}

extension MapBoxViewController: MGLMapViewDelegate {
    // MARK: - Map View's Delegates

    // TODO: USE ROUTER
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("*** Selected annotation")
        let id = annotationsID[annotation as! MGLPointAnnotation]!
        let selectedRoutePoint = routeController.findRoutePointBy(id: id)
        showDetail(of: selectedRoutePoint!)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    // TODO: FOR DEBUG PURPOSES.
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        print("*** Deselected annotation")
    }
    
    // MARK: - Actions
    
    // TODO: MOVE LOGIC TO INTERACTOR. PASS COORDINATE AS MODEL(REQUEST)
    @objc func handleMapLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        
        let longPressedPoint: CGPoint = sender.location(in: mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convert(longPressedPoint, toCoordinateFrom: mapView)
        
        print("*** Long pressed on the map.")
        
        newCreatedRP = routeController.createNextRoutePoint(at: coordinate)
        
        // TODO: It's a crutch. Segue to Annotation Edit is performed only after creation of route fragment in RouteController.
        if routeController.points.count == 1 {
            performSegue(withIdentifier: SeguesIdentifiers.showAnnotationEdit, sender: nil)
        }
    }
    
    // MARK: - Helper Methods
    
    // TODO: MOVE TO PRESENTER.
    private func setAnnotation(at routePoint: RoutePoint) {
        let annotation = MGLPointAnnotation()
        annotation.title = routePoint.title
        annotation.subtitle = routePoint.subtitle
        annotation.coordinate = routePoint.coordinate
        annotationsID[annotation] = routePoint.id
        mapView.addAnnotation(annotation)
    }
    
    
    // TODO: MOVE TO PRESENTER
    private func centerAt(location coordinate: CLLocationCoordinate2D, at zoomLevel: Double = 5.0) {
        mapView.setCenter(coordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    // TODO: MOVE TO PRESENTER
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
    
    // TODO: MOVE TO ROUTER
    func mapRoute(performEditFor routePoint: RoutePoint) {
        dismissDetail()
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationEdit, sender: routePoint)
    }
    
    // TODO: MOVE TO INTERACTOR
    func mapRoute(didDeleted routePoint: RoutePoint) {
        dismissDetail()
        routeController.delete(routePoint: routePoint)
    }
}

// TODO: MOVE TO INTERACTOR
extension MapBoxViewController: RoutePointEditDelegate {
    // MARK: - Route's Point Edit Delegate
    
    func route(pointCreated routePoint: RoutePoint) {
        routeController.update(routePoint: routePoint)
        setAnnotation(at: routePoint)
        
        setUIStatus(.routeMapping)
    }
    
    func route(pointEdited routePoint: RoutePoint) {
        routeController.update(routePoint: routePoint)
        print("*** Did edited: \(routePoint)")
    }
    
    func routePointCreationDidCancelled() {
        if let newCreatedRoutePoint = newCreatedRP {
            routeController.delete(routePoint: newCreatedRoutePoint)
            
            if routeController.points.count > 0 {
                setUIStatus(.routeMapping)
            } else {
                setUIStatus(.start)
            }
            
            newCreatedRP = nil
        }
    }
    
}

// TODO: MOVE TO PRESENTER
extension MapBoxViewController: RouteControllerDelegate {
    // MARK: - Route Controller's Delegate
    
    func routeController(didDeleted routePoint: RoutePoint) {
        for (annotation, id) in annotationsID {
            if id == routePoint.id {
                mapView.removeAnnotation(annotation)
                setUIStatus(.routeMapping)
            }
        }
    }
    
    func routeController(didCalculated routeFragment: RouteFragment) {
        drawRoute(routeCoordinates: routeFragment.coordinates, identifier: routeFragment.identifier)
        if let newCreatedPoint = newCreatedRP {
            performSegue(withIdentifier: SeguesIdentifiers.showAnnotationEdit, sender: newCreatedPoint)
        }
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
    
    func routeControllerDidUpdated() {
        setUIStatus(.routeMapping)
    }
    
    func routeControllerIsStartedRouting() {
        setUIStatus(.routing)
    }
    
    func routeControllerIsFinishedRouting() {
        setUIStatus(.routeMapping)
    }
    
    func routeControllerError(with routePoint: RoutePoint) {
        setUIStatus(.routeMapping)
        
        let alert = UIAlertController(title: "Route Creation Error", message: "Route to this point can not be created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        routeController.delete(routePoint: routePoint)
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
