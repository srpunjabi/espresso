//
//  CoffeShopViewModel.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/29/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation
import Alamofire

class NearbyViewModel
{
    //user's current location (both an Observer and an Observable)
    var locationVariable:Variable<CLLocation?> = Variable<CLLocation?>(CLLocation(latitude: 0, longitude: 0))
    
    //coffeeShops near the user (Observable that we bind to the UI)
    lazy var coffeeShops:Driver<[CoffeeShop]>! = self.fetchCoffeeShops()
    let disposeBag = DisposeBag()
    
    init(){}
  

    func fetchCoffeeShops() -> Driver<[CoffeeShop]>
    {
        return locationVariable
            .asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)   //delay network call by a few milliseconds
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS:.Background))
            
            .filter() // filter out initial 0, 0 coordinates
                {
                    (location:CLLocation?) -> Bool in
                    return ((location?.coordinate.latitude != 0) && (location?.coordinate.longitude != 0))
                }
            
            .distinctUntilChanged() // only call the network api for distinct location parameters
                {
                    (lhs:CLLocation?, rhs:CLLocation?) -> Bool in
                    return (lhs?.coordinate.latitude == rhs?.coordinate.latitude) && (lhs?.coordinate.longitude == rhs?.coordinate.longitude)
                }
            
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS:.Background))
            .flatMapLatest() // get the latest result among all network requests made
                {
                    location in
                    return FoursquareEndpoint.sharedInstance.getNearyByCoffeeShops(location!)
                }.asDriver(onErrorJustReturn:[]) // makes sure that the results are returned on the MainScheduler
    }
}

