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
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    func setupRx()
    {
        nearbyViewModel = NearbyViewModel()
        nearbyViewModel.coffeeShops.driveNext
                {
                    [unowned self]
                    shops in
                    for shop in shops
                    {
                        self.showPin(shop)
                    }
                }.addDisposableTo(disposeBag)
    }
    
    //shows pin on the map with annotation
    func showPin(coffeeShop:CoffeeShop)
    {
        guard let lat = coffeeShop.latitude else
        {
            return
        }
        
        guard let lng = coffeeShop.longitude else
        {
            return
        }
        
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = CoffeeShopAnnotation(title: coffeeShop.name, subtitle: nil, coordinate: coord)
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let latestLocation = locations.last
        {
            nearbyViewModel.locationVariable.value = latestLocation
            centerMapOnLocation(latestLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if(status == .AuthorizedWhenInUse)
        {
            mapView.showsUserLocation = true
            mapView.userLocation.title = "You are here"
            mapView.showsUserLocation = true
        }
    }
    
    //MARK: - Private Helpers
    
    //centers map to given coordinates on screen
    func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation =  annotation as? CoffeeShopAnnotation
        {
            let reuseId = "coffeePin"
            var view:MKPinAnnotationView
            
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            {
                view = dequedView
                view.annotation = annotation
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                view.image = UIImage(named: "ic_mail.png")
                view.canShowCallout = true
            }
            return view
        }
        return nil
    }

}




























