//
//  NavatarTableViewController.swift
//  Espresso
//
//  Created by Sumit Punjabi on 6/5/16.
//  Copyright © 2016 wakeupsumo. All rights reserved.
//

import UIKit

class NavatarTableViewController: UITableViewController
{
    let darthRow = 0
    let batmanRow = 1
    let hipsterRow = 2
    let ninjaRow = 3
    let knightRow = 4
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews()
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        let currentNavatarIndex = prefs.integerForKey("currentNavatarIndex")
        let indexPath = NSIndexPath(forRow: currentNavatarIndex, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }

    @IBAction func onDone(sender: UIBarButtonItem)
    {
        performSegueWithIdentifier("UnwindFromNavatar", sender: self)
    }
    
    //MARK: - TableView Delegates
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        //uncheck old cell
        let oldNavatarIndex = prefs.integerForKey("currentNavatarIndex")
        let oldIndexPath = NSIndexPath(forRow: oldNavatarIndex, inSection: 0)
        let oldCell = tableView.cellForRowAtIndexPath(oldIndexPath)
        oldCell?.accessoryType = .None

        //check new cell
        var navatarType:NavatarType
        let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
        
        //get selected NavatarType
        switch indexPath.row
        {
        case darthRow:
            navatarType = .DarthVader
        case batmanRow:
            navatarType = .Batman
        case ninjaRow:
            navatarType = .Ninja
        case hipsterRow:
            navatarType = .Hipster
        case knightRow:
            navatarType = .Knight
        default:
            navatarType = .DarthVader
        }
        
        //set imageName into prefs
        prefs.setValue(navatarType.rawValue, forKey: "userNavatar")
        prefs.setInteger(indexPath.row, forKey: "currentNavatarIndex")
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
    }
}
