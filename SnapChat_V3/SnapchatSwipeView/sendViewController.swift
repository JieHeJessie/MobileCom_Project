//
//  sendViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/11.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class sendViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Content to display for tableView
    var friends: [String] = []
    
    // Message content
    var image: UIImage?
    var timer: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the userNames array
        friends.appendContentsOf(Friends.getNames())
        
        // Set dataSource and delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// --------------------------- Table View -------------------------------
extension sendViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        let label = cell.viewWithTag(10) as! UILabel
        
        label.text = friends[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Send the message to the server
        //......
    }

}
