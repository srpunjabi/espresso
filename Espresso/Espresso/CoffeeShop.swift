//
//  CoffeShop.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/31/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import Foundation
import ObjectMapper

class CoffeeShop:Mappable
{
    var identifier:String!
    var name:String!
    var street:String?
    var city:String?
    var country:String?
    var latitude:String?
    var longitude:String?
    var distance:Int?
    var phone:String?
    
    required init?(_ map: Map)
    {
    
    }
    
    func mapping(map: Map)
    {
        identifier  <- map["id"]
        name        <- map["name"]
        street      <- map["location.0"]
        city        <- map["location.1"]
        country     <- map["location.2"]
        latitude    <- map["location.lat"]
        longitude   <- map["location.lng"]
        distance    <- map["location.distance"]
        phone       <- map["contact.phone"]
    }
}
