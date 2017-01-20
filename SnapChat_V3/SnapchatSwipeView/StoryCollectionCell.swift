//
//  CollectionTableViewCell.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/8.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class StoryCollectionCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewRelatedDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        
        collectionView.reloadData()
    }

}
