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

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var currentRouteNumber = 1
    
    
    // MARK: - View's Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUser()
    }
    
    // MARK: - Actions
    
    @IBAction func showUser() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func setPin(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        
        let location = sender.location(in: mapView)
        let locationCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoord
        annotation.title = "Route point #\(currentRouteNumber)"
        currentRouteNumber += 1
        
        //mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }

    @IBAction func cancelRouteCreation(_ sender: UIBarButtonItem) {
        mapView.removeAnnotations(mapView.annotations)
        currentRouteNumber = 1
    }
}
