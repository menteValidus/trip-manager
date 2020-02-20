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
    case start
    case pinning
    case routing
}

class GMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var routeLengthView: UIView!
    @IBOutlet weak var routeLengthLabel: UILabel!
    @IBOutlet weak var createRouteButton: UIButton!
    @IBOutlet weak var clearAllItem: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    var route: RouteDataModel!
    var markers: [GMSMarker] = []
    var routePolyline = GMSPolyline()
    
    private var status = MapViewStatus.start
    
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHUD()
        setupMap()
    }
    
    // MARK: - Actions
    
    @IBAction func clearAll(_ sender: Any) {
        route.deleteAll()
        
        for marker in markers {
            marker.map = nil
        }
        markers.removeAll()
        routePolyline.map = nil
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
        
        if route.isNotEmpty() {
            let path = GMSMutablePath()
            
            for routePoint in route.points {
                setMarker(at: routePoint)
                path.add(routePoint.coordinate)
            }
            
            if route.isProperForRouteCreation() {
                routePolyline = GMSPolyline(path: path)
                routePolyline.map = mapView
                status = .routing
            } else {
                status = .pinning
            }
            
        }
        
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
            UIView.animate(withDuration: animationDuration, animations: {
                self.routeLengthView.isHidden = false
                self.clearAllItem.isEnabled = true
            })
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
}
