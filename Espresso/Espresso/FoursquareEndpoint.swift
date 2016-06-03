//
//  FoursquareEndpoint.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/29/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//
import Alamofire
import SwiftyJSON
import Foundation
import ObjectMapper
import CoreLocation

class FoursquareEndpoint
{
    static let sharedInstance = FoursquareEndpoint()
    var client_key:String?
    var client_secret:String?
    
    private init()
    {
        guard let path = NSBundle.mainBundle().pathForResource("FoursquareKeys", ofType: "plist") else
        {
            print("failed path")
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) else
        {
            print("dict not found")
            return
        }
        
        client_key = dict["api_key"] as? String
        client_secret = dict["api_secret"] as? String
    }
    
    //This method calls the Foursquare API with location coordinates and retrieves the nearby coffeeShops
    func getNearyByCoffeeShops(location:CLLocation, completionHandler:(coffeeShopsNearby:[CoffeeShop])->Void) -> Request
    {
        let baseURL:String = "https://api.foursquare.com/v2/venues/search?"
        let params:[String : AnyObject] = buildSearchParameters(location)
        
        //GET request to Foursquare search API
        return Alamofire.request(.GET, baseURL, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
            .validate()
            .responseJSON()
                {
                    response in
                    
                    //validating the response
                    guard response.result.isSuccess else
                    {
                        print(response.result.error)
                        return
                    }
                    
                    //validating json format
                    guard let responseJSONValue = response.result.value as? [String: AnyObject] else
                    {
                        print("json failed: " + response.result.error.debugDescription)
                        return
                    }
               
                    //mapping json to CoffeeShop objects using ObjectMapper
                    if let coffeeShops = Mapper<CoffeeShop>().mapArray(responseJSONValue["response"]!["venues"])
                    {
                        completionHandler(coffeeShopsNearby: coffeeShops)
                    }
                }
    }
    
    private func buildSearchParameters(location:CLLocation) -> [String : AnyObject]
    {
        //preparing method parameters
        let query:String = "coffee"
        
        //date parameter
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let YYYYMMDD = dateFormatter.stringFromDate(date)
        
        //parameters dictionary
        let params:[String : AnyObject] =
            [
                "ll" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
                "query" : query,
                "client_id" : client_key!,
                "client_secret" : client_secret!,
                "v" : YYYYMMDD
        ]
        
        return params
    }
}