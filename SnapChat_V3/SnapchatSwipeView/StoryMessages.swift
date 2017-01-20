//
//  StoryMessages.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/12.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import Foundation
import UIKit
class StoryMessages{
    
    static var storyMessages:[StoryMessage] = [StoryMessage]()
    static var tableViewInTheStory: StoryViewController_TableView?
    
    // Initialize some data for testing
    static func initializeSomeData (){
        storyMessages.append(StoryMessage(content: "The beauty is from the inside heart",receivingTime: "22:22", image: UIImage(named: "The New York Times")!))
        storyMessages.append(StoryMessage(content: "The lucky is made from greate effort",receivingTime: "22:22", image: UIImage(named: "The Hill")!))
        storyMessages.append(StoryMessage(content: "Tommorrow is the day after today",receivingTime: "22:22",image: UIImage(named: "The Atlantic")!))
        storyMessages.append(StoryMessage(content: "!!!!!!!!!!!!!Sucess!!!!!!!!!",receivingTime: "22:22",image: UIImage(named: "TED")!))
    }
    
    // Get only the name attribute of each friends
    static func getContens() -> [String]{
        var contents: [String] = []
        for storyMessage in storyMessages {
            contents.append(storyMessage.content)
        }
        
        return contents
    }
    
    // Append the new content and update corresponding table view
    static func appendWithNewStoryMessage(storyMessage: StoryMessage){
        tableViewInTheStory?.storiesInMessageCell.append(storyMessage)
        tableViewInTheStory?.tableView.reloadData()
    }
    
}
