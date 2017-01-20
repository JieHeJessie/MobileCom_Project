//
//  MyFriendsTableViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/9.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class MyFriendsTableViewController: UITableViewController {
    
    var userNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the userNames array
        userNames.appendContentsOf(Friends.getNames())
        
        self.tableView.reloadData()
    }

// -----------------------------table View ------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let titleLabel = cell.viewWithTag(10) as! UILabel
        titleLabel.text = userNames[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
