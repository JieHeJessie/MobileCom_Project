//
//  Friend.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/12.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import Foundation
import UIKit

class User{
    
    var username: String
    var cellPhone: String?
    var age: String?
    
    // The static variable to store the current user and corresponding barCode image
    static var currentUser: User?
    static var currentUserBarCodeImage: UIImage?
    
    init (username:String, cellPhone: String?, age: String?){
        self.username = username
        self.cellPhone = cellPhone
        self.age = age
    }
    
    convenience init (username:String){
        self.init(username:username, cellPhone: nil,age: nil)
    }
}