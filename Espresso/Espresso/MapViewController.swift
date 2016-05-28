//
//  ViewController.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/27/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController
{

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
       
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        mapView.showsUserLocation = (status == .AuthorizedAlways)
        mapView.userLocation.title = "You are here"
    }
}