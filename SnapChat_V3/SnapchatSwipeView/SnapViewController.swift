//
//  SnapViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/1.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = []
    
    private let imageRatio: CGFloat = 1920/1080
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //images.append(UIImage(named: "Smithsonian")!)
        //images.append(UIImage(named: "Sunset")!)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
// -----------------------------Collection View ------------------------------
    // how many sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //number of items/cells in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return images.count
        
    }

    //cells for item at index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reusableCell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = images[indexPath.row]
        
        return cell
    }
    
    // Did select some cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        // Get the cell selected
        let imageCell = collectionView.cellForItemAtIndexPath(indexPath)
        
        // Go to edit view controller
        performSegueWithIdentifier("goToEditInMemory", sender: imageCell)
    }
    
    // Layout Settings
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3 - 1
        
        return CGSize(width: width, height: width * imageRatio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func reloadCollectionView(){

        collectionView.reloadData()

    }
    
// -----------------------------Segue preparation ------------------------------
    // Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! ImageEditViewController_Same
        let imageCell = sender as! UICollectionViewCell
        
        let imageView = imageCell.viewWithTag(100) as! UIImageView
        let image = imageView.image
        
        // Send the data to the destination
        destination.image = image
        destination.indexPath = collectionView.indexPathForCell(imageCell)
        destination._parentViewController = self
    }
    
    // unwind function
    @IBAction func unwindToSnap(segue: UIStoryboardSegue) {}

}
