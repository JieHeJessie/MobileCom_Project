//
//  shakeShakeMessage.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/13.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import Foundation

class shakeShakeMessage: Equatable{
    
    var username: String
    var content: String
    
    init(username: String, content: String){
        self.username = username
        self.content = content
    }

}

// ----------------------------- Custom definition of == operator------------------------------
func == (left: shakeShakeMessage, right: shakeShakeMessage) -> Bool{
    return left.username == right.username && left.content == left.content
}