//
//  ViewController.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/27/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var nearbyViewModel:NearbyViewModel!
    var disposeBag = DisposeBag()
    var coffeeShops:[CoffeeShop] = [CoffeeShop]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupRx()
        setupLocation()
    }
    
    func setupLocation()
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }

    }
    
    func setupRx()
    {
        nearbyViewModel = NearbyViewModel()
        nearbyViewModel.fetchCoffeeShops().driveNext
                { shops in
                    for shop in shops
                    {
                        print(shop.distance)
                    }
                }.addDisposableTo(disposeBag)
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let latestLocation = locations.last
        {
            nearbyViewModel.locationVariable.value = latestLocation
        }
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