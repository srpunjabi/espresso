//
//  CoffeeShopAnnotation.swift
//  Espresso
//
//  Created by Sumit Punjabi on 6/3/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import Foundation
import MapKit

class CoffeeShopAnnotation: NSObject, MKAnnotation
{
    let title:String?
    let subtitle:String?
    let coordinate:CLLocationCoordinate2D
    
    init(title:String?, subtitle:String?, coordinate:CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }

}