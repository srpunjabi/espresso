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
    var latitude:Double?
    var longitude:Double?
    var distance:Double?
    var phone:String?
    var phoneBasic:String?
    var url:String?
    
    required init?(_ map: Map)
    {
    
    }
    
    func mapping(map: Map)
    {
        identifier  <- map["id"]
        name        <- map["name"]
        street      <- map["location.formattedAddress.0"]
        city        <- map["location.formattedAddress.1"]
        country     <- map["location.formattedAddress.2"]
        latitude    <- map["location.lat"]
        longitude   <- map["location.lng"]
        distance    <- map["location.distance"]
        phoneBasic  <- map["contact.phone"]
        phone       <- map["contact.formattedPhone"]
        url         <- map["url"]
    }
}
