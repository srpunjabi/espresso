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
    @IBOutlet weak var myLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var nearbyViewModel:NearbyViewModel!
    var disposeBag = DisposeBag()
    var coffeeShops:[CoffeeShop] = [CoffeeShop]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.bringSubviewToFront(myLocationButton)
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
        let annotation = CoffeeShopAnnotation(title: coffeeShop.name, coordinate: coord,type: .CoffeeShop)
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func showMyLocation(sender: UIButton)
    {
        if(CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse && CLLocationManager.locationServicesEnabled())
        {
            nearbyViewModel.locationVariable
                .asDriver()
                .filter()
                    {
                        (location:CLLocation?) -> Bool in
                        return ((location?.coordinate.latitude != 0) && (location?.coordinate.longitude != 0))
                    }
                .driveNext()
                    {
                            [unowned self]
                            (location:CLLocation?) in
                            if let currentLocation = location
                            {
                                self.centerMapOnLocation(currentLocation)
                            }
                    }.addDisposableTo(disposeBag)
        }
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
            addCurrentUserAnnotation(latestLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        removeCurrentUserAnnotation()
        addCurrentUserAnnotation(newLocation)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if(status == .AuthorizedWhenInUse)
        {
            mapView.showsUserLocation = false
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
    
    func addCurrentUserAnnotation(location:CLLocation)
    {
        let userAnnotation = CoffeeShopAnnotation(title: "Me", coordinate: location.coordinate, type:.User)
        userAnnotation.imageName = "darthVader.png"
        mapView.addAnnotation(userAnnotation)
    }
    
    func removeCurrentUserAnnotation()
    {
        let annotationToRemove = mapView.annotations.filter
            {
                let annotation = $0 as? CoffeeShopAnnotation
                return (annotation?.annotationType == .User) ?? false
        }
        mapView.removeAnnotations(annotationToRemove)
    }
}

extension MapViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation =  annotation as? CoffeeShopAnnotation
        {
            let reuseId = "coffeePin"
            var view:MKAnnotationView
            if let dequedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as MKAnnotationView?
            {
                view = dequedView
                view.annotation = annotation
            }
            else
            {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                view.canShowCallout = true
            }
            view.image = UIImage(named: annotation.imageName)
            return view
        }
        
        return nil
    }
}




























