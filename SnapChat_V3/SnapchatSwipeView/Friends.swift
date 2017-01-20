//
//  Friends.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/12.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import Foundation

class Friends{

    static var friends:[User] = [User]()
    
    // Initialize some data for testing
    static func initializeSomeData (){
        friends.append(User(username: "Xiaolei Liu"))
        friends.append(User(username: "Hua Hua"))
        friends.append(User(username: "Steve Guo"))
        friends.append(User(username: "Jie He"))
    }
    
    // Get only the name attribute of each friends
    static func getNames() -> [String]{
        var names: [String] = []
        for friend in friends {
            names.append(friend.username)
        }
        
        return names
    }
    
}
