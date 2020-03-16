//
//  GMapViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 18.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

enum MapViewStatus {
    // First launch/New route creation
    case start
    // Stage of pins setting
    case pinning
    // Stage of route creation, waiting for API response.
    case routing
    // Stage of route's mapping
    case routeMapping
}

class GMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var routeLengthView: UIView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var createRouteButton: UIButton!
    @IBOutlet weak var clearAllItem: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    let gmapApiRepository = GMapApiRepository()
    
    var route: RouteDataModel!
    var markers: [GMSMarker] = []
    var routePolylines: [GMSPolyline] = []
    
    private var status = MapViewStatus.start
    
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHUD()
        setupMap()
    }
    
    // MARK: - Actions
    
    @IBAction func clearAll(_ sender: Any) {
        setUIStatus(.pinning)
        
        route.deleteAll()
        
        markers.forEach {
            $0.map = nil
        }
        markers.removeAll()
        
        routePolylines.forEach {
            $0.map = nil
        }
        routePolylines.removeAll()
    }
    
    @IBAction func createRoute(_ sender: Any?) {
        for i in 0..<(route.points.count - 1) {
            let sourceCoord = route.points[i].coordinate
            let destinationCoord = route.points[i + 1].coordinate
            gmapApiRepository.fetchDirection(sourceCoord: sourceCoord, destinationCoord: destinationCoord) { polylineString in
                self.drawPolyline(from: polylineString)
                self.setUIStatus(.routeMapping)
            }
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

extension GMapViewController: CLLocationManagerDelegate {
    
}

extension GMapViewController: GMSMapViewDelegate {
    // MARK: - GMS Map View's Delegate
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let newRoutePoint = route.createRoutePointWithoutAppending()
        newRoutePoint.coordinate = coordinate
        
        setMarker(at: newRoutePoint)
        
        route.add(point: newRoutePoint)
    }
    
    // MARK: - Helper Methods
    
    private func setMarker(at routePoint: RoutePoint) {
        let marker = RoutePin(routeID: routePoint.id, position: routePoint.coordinate)
        marker.title = routePoint.title
        marker.map = mapView
        
        markers.append(marker)
    }
    
    private func drawPolyline(from polylineString: String) {
        let path = GMSPath(fromEncodedPath: polylineString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView
        routePolylines.append(polyline)
    }
}
