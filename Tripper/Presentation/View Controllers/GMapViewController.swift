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

class GMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var route: RouteDataModel!
    
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupMap()
        // Do any additional setup after loading the view.
    }
    // MARK: - UI
    
    private func setupMap() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if route.isNotEmpty() {
            for point in route.points {
                setMarker(at: point)
            }
        }
    }

}

extension GMapViewController: CLLocationManagerDelegate {
    
}

extension GMapViewController: GMSMapViewDelegate {
    // MARK: - GMS Map View's Delegate
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        var newRoutePoint = RoutePoint()
        newRoutePoint.coordinate = coordinate
        
        setMarker(at: newRoutePoint)
        
        route.add(point: newRoutePoint)
    }
    
    // MARK: - Helper Methods
    
    private func setMarker(at routePoint: RoutePoint) {
        let marker = GMSMarker(position: routePoint.coordinate)
        marker.title = routePoint.title
        marker.map = mapView
    }
}
