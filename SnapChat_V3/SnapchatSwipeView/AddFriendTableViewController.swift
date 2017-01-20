//
//  AddFriendTableViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/9.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class AddFriendTableViewController: UITableViewController {
    
    var addFriendWays: [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFriendWays.append("Add friends through username")
        addFriendWays.append("Add friends through SnapCode")
        addFriendWays.append("Add friends through sharing users")
        
        self.tableView.reloadData()

    }

// -----------------------------table View ------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addFriendWays.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let titleLabel = cell.viewWithTag(10) as! UILabel
        titleLabel.text = addFriendWays[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("goToSearchTableViewController", sender: self)
        case 1:
            performSegueWithIdentifier("goToScan", sender: self)
        case 2:
            performSegueWithIdentifier("goToSocialShare", sender: self)
        default:
            print ("Wrong index-- AddFriendTableViewController")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
// -----------------------------Segue preparation ------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToSocialShare"){
            let destination = segue.destinationViewController as! socialShareViewController
            destination.image = User.currentUserBarCodeImage
        }
    }
}