//
//  SubcriptionCell.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/8.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class SubcriptionCell: UITableViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var subcriptionContentLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    
    func setImageWith(image: UIImage?, content:String, optionLabel: String?){
        
        subcriptionContentLabel.text = content
        
        if (optionLabel != nil){
            self.optionalLabel.text = optionLabel
        }else {
            self.optionalLabel.text = ""
        }
        
        if (image != nil){
            imageView1.image = image
        }else {
        }
    }
}
