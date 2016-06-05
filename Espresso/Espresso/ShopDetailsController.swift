//
//  TableViewController.swift
//  Espresso
//
//  Created by Sumit Punjabi on 6/4/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailsController: UITableViewController
{    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var webSiteLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var coffeeShop:CoffeeShop?
    let addressSection = 0
    let addressRow = 0
    let infoSection = 1
    let directionCellRow = 1
    let phoneCellRow = 2
    let webCellRow = 3
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        setup()
    }
    
    //MARK: - Setup
    
    func setup()
    {
        if let coffeeShop = coffeeShop
        {
            nameLabel.text = coffeeShop.name
            setupAddressLabel(coffeeShop)
            setUpPhoneLabel(coffeeShop)
            setUpWebsiteLabel(coffeeShop)
            setUpDistance(coffeeShop)
            showPin(coffeeShop)
        }
    }
    
    //MARK: - Setup Helpers
    
    func setupAddressLabel(shop:CoffeeShop)
    {
        guard let street = shop.street  else { return }
        guard let city = shop.city      else { return }
        addressLabel.text = "\(street)\n" + "\(city)"
    }
    
    func setUpWebsiteLabel(shop:CoffeeShop)
    {
        guard let url = shop.url else
        {
            webSiteLabel.text = "No"
            return
        }
        webSiteLabel.text = url
    }
    
    func setUpDistance(shop:CoffeeShop)
    {
        guard let distance = shop.distance else
        {
            distanceLabel.text = "0.0"
            return
        }
        var distanceInMiles = distance * 0.000621371192
        distanceInMiles = Double(round(distanceInMiles * 100)/100)
        distanceLabel.text = "\(distanceInMiles) mi"
    }
    
    func setUpPhoneLabel(shop:CoffeeShop)
    {
        guard let phone = shop.phone else
        {
            phoneNumberLabel.text = "No"
            return
        }
        phoneNumberLabel.text = phone
    }
    
    //MARK: - UITableView Delegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case webCellRow where indexPath.section == infoSection:    //open webpage
            openWebURL()
        case phoneCellRow where indexPath.section == infoSection:  //make a call
            openPhoneURL()
        case directionCellRow where indexPath.section == infoSection: //open maps
            openMapURL()
        case addressRow where indexPath.section == addressSection:
            openMapURL()
        default:
            break
        }
    }

    //MARK: -  URL Helpers
    
    func openWebURL()
    {
        guard let sURL = coffeeShop?.url else { return }
        guard let url = NSURL(string: sURL) else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    func openPhoneURL()
    {
        guard let phone = coffeeShop?.phoneBasic else { return }
        guard let url = NSURL(string: "tel:+1\(phone)") else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    func openMapURL()
    {
        guard let street = coffeeShop?.street?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            else { return }
        guard let city = coffeeShop?.city?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            else { return }
        guard let url = NSURL(string: "http://maps.apple.com/?daddr=\(street)\(city)")
            else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    //MARK: - Location Helpers
    
    func centerMapOnLocation(coord: CLLocationCoordinate2D)
    {
        let regionRadius: CLLocationDistance = 100
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coord, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showPin(coffeeShop:CoffeeShop)
    {
        guard let lat = coffeeShop.latitude  else   { return }
        guard let lng = coffeeShop.longitude else   { return }
        
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let annotation = CoffeeShopAnnotation(title: coffeeShop.name, coordinate: coord,type: .CoffeeShop, id: coffeeShop.identifier)
        mapView.addAnnotation(annotation)
        centerMapOnLocation(coord)
    }
}

extension ShopDetailsController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? CoffeeShopAnnotation else {   return nil }
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
            view.image = UIImage(named: annotation.imageName)
        }
        return view
    }
}