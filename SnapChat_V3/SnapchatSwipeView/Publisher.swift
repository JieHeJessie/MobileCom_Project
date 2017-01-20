//
//  Publisher.swift
//  PrettyApple
//
//  Created by Duc Tran on 7/21/15.
//  Copyright © 2015 Developer Inspirus. All rights reserved.
//

import UIKit

class Publisher: Hashable
{
    var title: String
    var url: String
    var image: UIImage
    var section: String
    
    init(title: String, url: String, image: UIImage, section: String)
    {
        self.title = title
        self.url = url
        self.image = image
        self.section = section
    }
    
    convenience init(copies publisher: Publisher)
    {
        self.init(title: publisher.title, url: publisher.url, image: publisher.image, section: publisher.section)
    }
    
    //MARK: - Hashable
    var hashValue: Int{
        get {
            return title.hashValue
        }
    }
}

//MARK: - Equatable
func == (lhs: Publisher, rhs: Publisher) -> Bool{
    return (lhs.title == rhs.title) && (lhs.section == rhs.section)
}























