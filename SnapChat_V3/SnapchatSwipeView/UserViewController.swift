//
//  UserViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/9.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create for testing
        username = User.currentUser?.username
        
        // Get the bar code of current user
        imageView.image = User.currentUserBarCodeImage
    }

}
