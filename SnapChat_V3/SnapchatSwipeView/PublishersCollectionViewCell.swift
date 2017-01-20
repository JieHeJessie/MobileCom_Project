//
//  PublishersCollectionViewCell.swift
//  News
//
//  Created by HEJIE on 28/09/2016.
//  Copyright © 2016 Developer Inspirus. All rights reserved.
//

import UIKit

class PublishersCollectionViewCell: UICollectionViewCell {
    
    // UI Item
    @IBOutlet var publisherimageView: UIImageView!
    @IBOutlet var visualEffectiveView: UIVisualEffectView!
    @IBOutlet var publisherTitleLabel: UILabel!
    
    var publisher: Publisher?{
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        publisherimageView.image = publisher?.image
    }
}

