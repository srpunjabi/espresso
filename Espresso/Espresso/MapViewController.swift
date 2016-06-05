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
    var coffeeShopDict:[String : CoffeeShop] = [String : CoffeeShop]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.bringSubviewToFront(myLocationButton)
        setupRx()
        setupLocation()
    }
    
    //MARK: Setup
    
    func setupRx()
    {
        nearbyViewModel = NearbyViewModel()
        nearbyViewModel.coffeeShops.driveNext
            {
                [unowned self]
                shops in
                for shop in shops
                {
                    if(self.coffeeShopDict[shop.identifier] == nil)
                    {
                        self.coffeeShopDict[shop.identifier] = shop
                    }
                    self.showPin(shop)
                }
            }.addDisposableTo(disposeBag)
    }
    
    func setupLocation()
    {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            if #available(iOS 9.0, *)
            {
                locationManager.requestLocation()
            }
        }
    }
    
    //MARK: IBActions
    
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
    
    @IBAction func unwindFromNavatar(segue:UIStoryboardSegue)
    {
        if let location = nearbyViewModel.locationVariable.value
        {
            removeCurrentUserAnnotation()
            addCurrentUserAnnotation(location)
        }
    }
    
    @IBAction func chooseNavatar(sender: UIBarButtonItem)
    {
        performSegueWithIdentifier("MapToNavatar", sender: self)
    }
    
    //MARK: Segue Logic
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let _ = segue.identifier where segue.identifier == "MapToDetailsSegue"
        {
            guard let detailsController = segue.destinationViewController as? ShopDetailsController else { return }
            
            guard let id = sender as? String else { return }
            detailsController.coffeeShop = coffeeShopDict[id]
        }
    }
    
    //MARK: - Private Helpers
    
    //shows pin on the map with annotation
    private func showPin(coffeeShop:CoffeeShop)
    {
        guard let lat = coffeeShop.latitude  else { return }
        guard let lng = coffeeShop.longitude else { return }
       
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = CoffeeShopAnnotation(title: coffeeShop.name, coordinate: coord,type: .CoffeeShop, id: coffeeShop.identifier)
        mapView.addAnnotation(annotation)
    }
    
    //centers map to given coordinates on screen
    private func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
            removeCurrentUserAnnotation()
            addCurrentUserAnnotation(latestLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        removeCurrentUserAnnotation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if(status == .AuthorizedWhenInUse)
        {
            mapView.showsUserLocation = false
        }
    }
    
    //MARK: - Annotation Helpers
    
    //adds a new annotation for user's current location
    func addCurrentUserAnnotation(location:CLLocation)
    {
        let userAnnotation = CoffeeShopAnnotation(title: "Me", coordinate: location.coordinate, type:.User, id: "user")
        let prefs = NSUserDefaults.standardUserDefaults()
        if let imageName = prefs.stringForKey("userNavatar")
        {
            userAnnotation.imageName = imageName
            mapView.addAnnotation(userAnnotation)
        }
    }
    
    //removes any old user annotations when user's current location updates
    func removeCurrentUserAnnotation()
    {
        let annotationToRemove = mapView.annotations.filter
            {
                let annotation = $0 as? CoffeeShopAnnotation
                return (annotation?.annotationType == .User)
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
                view.canShowCallout = (annotation.annotationType == .CoffeeShop)
            }
            else
            {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                let frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                let detailsButton = UIButton(frame: frame)
                detailsButton.setBackgroundImage(UIImage(named: "ic_right.png"), forState: .Normal)
                view.rightCalloutAccessoryView = detailsButton
                view.canShowCallout = (annotation.annotationType == .CoffeeShop)
            }
            view.image = UIImage(named: annotation.imageName)
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
            if let coffeeAnnotation = view.annotation as? CoffeeShopAnnotation
            {
                self.performSegueWithIdentifier("MapToDetailsSegue", sender: coffeeAnnotation.id)
            }
    }
}