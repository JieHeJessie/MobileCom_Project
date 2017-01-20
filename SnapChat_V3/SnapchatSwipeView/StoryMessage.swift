//
//  StoryMessage.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/12.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit
class StoryMessage{

    var content: String
    var receivingTime: String
    var sender: User?
    var image: UIImage?
    
    init (content:String, receivingTime: String, sender: User?, image: UIImage?){
        self.content = content
        self.receivingTime = receivingTime
        self.sender = sender
        self.image = image
    }
    
    convenience init (content: String, receivingTime: String){
        self.init(content: content, receivingTime: receivingTime, sender: nil,image: nil)
    }
    
    convenience init (content: String, receivingTime: String, image: UIImage){
        self.init(content: content, receivingTime: receivingTime, sender: nil,image: image)
    }
}