//
//  tableViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/9.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class AddedFriendTableViewController: UITableViewController {
    
    var titles: [String]! = []
    var details: [String]! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the current addedFriendMessages
        let addedFriendMessages = AddedFriendMessages.addedFriendMessages
        
        for addedFriendMessage in addedFriendMessages{
            titles.append(addedFriendMessage.username)
            details.append(addedFriendMessage.time)
        }

        self.tableView.reloadData()
    }
    
// -----------------------------table View ------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let titleLabel = cell.viewWithTag(10) as! UILabel
        let detailLabel = cell.viewWithTag(20) as! UILabel
        
        titleLabel.text = titles[indexPath.row]
        detailLabel.text = details[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
