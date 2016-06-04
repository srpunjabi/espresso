//
//  CoffeeShopAnnotation.swift
//  Espresso
//
//  Created by Sumit Punjabi on 6/3/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import Foundation
import MapKit

enum CoffeeShopAnnotationType
{
    case User
    case CoffeeShop
}

class CoffeeShopAnnotation: NSObject, MKAnnotation
{
    let title:String?
    let coordinate:CLLocationCoordinate2D
    var imageName:String
    var annotationType:CoffeeShopAnnotationType
    
    init(title:String?, coordinate:CLLocationCoordinate2D, type:CoffeeShopAnnotationType)
    {
        self.title = title
        self.coordinate = coordinate
        self.imageName = "coffeePin.png"
        self.annotationType = type
        super.init()
    }

}