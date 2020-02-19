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
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
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
        
        placesClient = GMSPlacesClient.shared()
    }

}

extension GMapViewController: CLLocationManagerDelegate {
    
}

extension GMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = "hey"
        marker.map = mapView
    }
}
