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
    
    var route: RouteDataModel!
    private var status = MapViewStatus.start
    private var annotationsID: Dictionary<MGLPointAnnotation, String> = Dictionary()
    private var shapeSources: [MGLShapeSource] = []
    private var shapeLineStyles: [MGLLineStyleLayer] = []
    
    private var remainingRouteSegmentsToCalculate = 0
    
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
        
        routeEstimationView.layer.cornerRadius = 16
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        registerGestureRecognizers()
        
        for routePoint in route.points {
            setAnnotation(at: routePoint)
        }
        
        if route.points.count != 0 {
            centerAt(location: route.points[0].coordinate)
        }
        
        if route.isProperForRouteCreation() {
            setUIStatus(.routing)
            createRoute()
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
        if let annotations = mapView.annotations {
            for annotation in annotations {
                mapView.removeAnnotation(annotation)
            }
        }
        
        for source in shapeSources {
            mapView.style?.removeSource(source)
        }
        
        for style in shapeLineStyles {
            mapView.style?.removeLayer(style)
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
    
    /**
     Method which handles route creation and mapping.
     Automatically switch UI status to .routeMapping at the end of creation.
     */
    private func createRoute() {
        remainingRouteSegmentsToCalculate = route.points.count - 1
                // TODO: Odd one
        let lastIndex = route.points.count - 1
        for i in 0..<lastIndex {
            let identifier = route.points[i].id + route.points[i + 1].id
            let sourceCoord = route.points[i].coordinate
            let destinationCoord = route.points[i + 1].coordinate
            calculateRoute(from: sourceCoord, to: destinationCoord, drawHandler: { route in
                self.drawRoute(routeCoordinates: route!.shape!.coordinates, identifier: identifier)
                self.remainingRouteSegmentsToCalculate -= 1
                
                // Assign time and distance of the route to the source route point.
                self.route.points[i].distanceToNextPointInMeters = Int(route!.distance)
                self.route.points[i].timeToNextPointInMinutes = Int(route!.expectedTravelTime / 60)
                
                if self.remainingRouteSegmentsToCalculate == 0 {
                    self.setUIStatus(.routeMapping)
                }
            })
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
        performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: selectedRoutePoint)
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
        
        let newRoutePoint = route.createRoutePointWithoutAppending()
        newRoutePoint.coordinate = coordinate
        route.add(point: newRoutePoint)
        setAnnotation(at: newRoutePoint)
        
        if route.isProperForRouteCreation() {
            let indexOfCreatedRoutePoint = route.points.count - 1
            let indexOfPreviousPoint = indexOfCreatedRoutePoint - 1
            
            route.layout(from: route.points[indexOfPreviousPoint], to: route.points[indexOfCreatedRoutePoint],
                        completionHandler: { routeInformation in
                            
                let firstPointInRouteFragment = self.route.points[indexOfPreviousPoint]
                            firstPointInRouteFragment.timeToNextPointInSeconds = routeInformation.travelTimeInSeconds
                            firstPointInRouteFragment.distanceToNextPointInMeters = routeInformation.travelDistanceInMeters
                         
                // Update departure date of new point according on time to get there.
                let lastPointInRouteFragment = self.route.points[indexOfCreatedRoutePoint]
                let timeIntervalBetweenPoints = TimeInterval(integerLiteral: Int64((firstPointInRouteFragment.timeToNextPointInSeconds ?? 0)))
                lastPointInRouteFragment.arrivalDate = firstPointInRouteFragment.departureDate?.addingTimeInterval(timeIntervalBetweenPoints)
                self.route.update(routePoint: firstPointInRouteFragment)
                            
                self.setUIStatus(.routeMapping)
                            
                self.performSegue(withIdentifier: SeguesIdentifiers.showAnnotationDetail, sender: newRoutePoint)
            })
        } else {
            setMapCameraAt(coordinates: [newRoutePoint.coordinate])
        }
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
    
    private func createRoute(from source: RoutePoint, to destination: RoutePoint) {
        self.setUIStatus(.routing)
        route.layout(from: source, to: destination, completionHandler: { routeInformation in
            self.drawRoute(routeCoordinates: routeInformation.coordinates, identifier: source.id + destination.id)
            source.timeToNextPointInSeconds = routeInformation.travelTimeInSeconds
            source.distanceToNextPointInMeters = routeInformation.travelDistanceInMeters
            
            // Update departure date of new point according on time to get there.
            
            let timeIntervalBetweenPoints = TimeInterval(integerLiteral: Int64((source.timeToNextPointInSeconds ?? 0)))
            destination.arrivalDate = source.departureDate?.addingTimeInterval(timeIntervalBetweenPoints)
            self.route.update(routePoint: source)
            self.route.update(routePoint: destination)
                        
            self.setUIStatus(.routeMapping)
        })
    }
    
    
    
    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, drawHandler: @escaping (Route?) -> Void) {
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let sourceWaypoint = Waypoint(coordinate: source, coordinateAccuracy: -1, name: "Start")
        let destinationWaypoint = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [sourceWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        Directions.shared.calculate(options, completionHandler: { (_, routes, _) in
            drawHandler(routes?.first)
        })
    }
    
    private func drawRoute(routeCoordinates: [CLLocationCoordinate2D], identifier: String) {
        guard routeCoordinates.count > 0 else { return }
        
        let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: UInt(routeCoordinates.count))
        
        let source = MGLShapeSource(identifier: identifier, features: [polyline], options: nil)
        
        // Customize the route line color and width
        let lineStyle = MGLLineStyleLayer(identifier: identifier, source: source)
        lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        lineStyle.lineWidth = NSExpression(forConstantValue: 3)
        
        mapView.style?.addSource(source)
        shapeSources.append(source)
        mapView.style?.addLayer(lineStyle)
        shapeLineStyles.append(lineStyle)
        
    }
    
    private func deleteRoutePointWithRouteCorrection(routePoint: RoutePoint) {
        for (annotation, id) in annotationsID {
            if id == routePoint.id {
                mapView.removeAnnotation(annotation)
                annotationsID.removeValue(forKey: annotation)
                break
            }
        }
        
        guard let indexOfDeletedPoint = route.getIndex(of: routePoint) else { return }
        route.delete(routePoint: routePoint)
        
        if !route.points.isEmpty {
            
            switch indexOfDeletedPoint {
            case 0:
                let indexOfOverlayAfterDeletingPoint = indexOfDeletedPoint
                // Remove overlay line after deleting point.
                let shapeSourceAfterDeletingPoint = shapeSources[indexOfOverlayAfterDeletingPoint]
                mapView.style?.removeSource(shapeSourceAfterDeletingPoint)
                
                let lineStyleAfterDeletingPoint = shapeLineStyles[indexOfOverlayAfterDeletingPoint]
                mapView.style?.removeLayer(lineStyleAfterDeletingPoint)
                
                shapeSources.remove(at: indexOfOverlayAfterDeletingPoint)
                shapeLineStyles.remove(at: indexOfOverlayAfterDeletingPoint)
                
                self.setUIStatus(.routeMapping)
                
            case route.points.count: // Last index. It's not (...count - 1) because point is already deleted from array.
                let indexOfOverlayBeforeDeletingPoint = indexOfDeletedPoint - 1
                // Remove overlay lines before deleting point.
                let shapeSourceBeforeDeletingPoint = shapeSources[indexOfOverlayBeforeDeletingPoint]
                mapView.style?.removeSource(shapeSourceBeforeDeletingPoint)
                
                let lineStyleBeforeDeletingPoint = shapeLineStyles[indexOfOverlayBeforeDeletingPoint]
                mapView.style?.removeLayer(lineStyleBeforeDeletingPoint)
                
                shapeSources.remove(at: indexOfOverlayBeforeDeletingPoint)
                shapeLineStyles.remove(at: indexOfOverlayBeforeDeletingPoint)
                
                self.setUIStatus(.routeMapping)
                
            default:
                let indexOfOverlayBeforeDeletingPoint = indexOfDeletedPoint - 1
                // Remove overlay lines before deleting point.
                let shapeSourceBeforeDeletingPoint = shapeSources[indexOfOverlayBeforeDeletingPoint]
                mapView.style?.removeSource(shapeSourceBeforeDeletingPoint)
                let lineStyleBeforeDeletingPoint = shapeLineStyles[indexOfOverlayBeforeDeletingPoint]
                mapView.style?.removeLayer(lineStyleBeforeDeletingPoint)
                
                let indexOfOverlayAfterDeletingPoint = indexOfDeletedPoint
                // Remove overlay lines after deleting point.
                let shapeSourceAfterDeletingPoint = shapeSources[indexOfOverlayAfterDeletingPoint]
                mapView.style?.removeSource(shapeSourceAfterDeletingPoint)
                let lineStyleAfterDeletingPoint = shapeLineStyles[indexOfOverlayAfterDeletingPoint]
                mapView.style?.removeLayer(lineStyleAfterDeletingPoint)
                
                shapeSources.removeAll(where: { shapeSource in
                    if shapeSource == shapeSourceBeforeDeletingPoint || shapeSource == shapeSourceAfterDeletingPoint {
                        return true
                    } else {
                        return false
                    }
                })
                
                shapeLineStyles.removeAll(where: { lineStyle in
                    if lineStyle == lineStyleBeforeDeletingPoint || lineStyle == lineStyleAfterDeletingPoint {
                        return true
                    } else {
                        return false
                    }
                })
                
                let sourceRoutePoint = route.points[indexOfDeletedPoint - 1]
                let newDestinationRoutePoint = route.points[indexOfDeletedPoint]
                
                // Create new route fragment into gap
                createRoute(from: sourceRoutePoint, to: newDestinationRoutePoint)
                
            }
            
        }
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
        deleteRoutePointWithRouteCorrection(routePoint: routePoint)
    }
}

extension MapBoxViewController: RoutePointEditDelegate {
    // MARK: - Route's Point Edit Delegate
    
    func route(pointEdited routePoint: RoutePoint) {
        route.update(routePoint: routePoint)
        print("*** Did edited: \(routePoint)")
    }
}
