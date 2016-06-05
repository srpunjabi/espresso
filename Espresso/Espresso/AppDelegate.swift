//
//  AppDelegate.swift
//  Espresso
//
//  Created by Sumit Punjabi on 5/27/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        guard let _ = prefs.stringForKey("userNavatar")  else
        {
            prefs.setValue(NavatarType.DarthVader.rawValue, forKey: "userNavatar")
            return true
        }
        return true
    }
}

