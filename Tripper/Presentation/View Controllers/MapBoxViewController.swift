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
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        registerGestureRecognizers()
        
        for routePoint in route.points {
            setMarker(at: routePoint)
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
            let sourceCoord = route.points[i].coordinate
            let destinationCoord = route.points[i + 1].coordinate
        
//            gmapApiRepository.fetchDirection(sourceCoord: sourceCoord, destinationCoord: destinationCoord) { polylineString in
//                self.drawPolyline(from: polylineString)
//                self.setUIStatus(.routeMapping)
//            }
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
            setMarker(at: routePoint)
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
        
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        
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
        setMarker(at: newRoutePoint)
    }
    
    // MARK: - Helper Methods
    
    private func setMarker(at routePoint: RoutePoint) {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = routePoint.coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func drawPolyline(from polylineString: String) {
//        let path = GMSPath(fromEncodedPath: polylineString)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 3.0
//        polyline.map = mapView
//        routePolylines.append(polyline)
    }
}
