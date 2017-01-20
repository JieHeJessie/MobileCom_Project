//
//  ViewController.swift
//  photoCollectionView
//
//  Created by lavintyben on 16/9/27.
//  Copyright © 2016年 WHatEVer. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageArray = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoaded = false
    
    
    override func viewDidLoad() {

        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicator.startAnimating()
        
        // Add a long press gesture recognizer to the collection view(working on the cell)
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(PhotoAlbumViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.3
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (imageArray.count == 0){
            grabPhotos()
            self.collectionView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.imageView.hidden = true
        self.collectionView.userInteractionEnabled = true
    }
    
    func grabPhotos(){
        
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.deliveryMode = .HighQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions){
            
            if fetchResult.count > 0{
                
                for i in 0..<fetchResult.count{
                    
                    let asset = fetchResult.objectAtIndex(i) as! PHAsset
                    
                    let originalPhotoWidth = asset.pixelWidth
                    let orginalPhotoHeight = asset.pixelHeight
                    let originalPhotoSize = CGSize(width:originalPhotoWidth,height:orginalPhotoHeight)
                    
                    imgManager.requestImageForAsset(asset, targetSize: originalPhotoSize, contentMode: .AspectFill, options: requestOptions, resultHandler: {
                        (image, error) in
                        
                        self.imageArray.append(image!)
                        
                    })
                    
                }
                
            }
            
            
        }else{
            
            print("You got no photos!")
            self.collectionView.reloadData()
            
        }
        
    }
    
    // Data Source Settings
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    // See the preview of the photo in full screen when click its snapshoot
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.imageView.image = imageArray[indexPath.row]
        imageView.hidden = false
        self.collectionView.userInteractionEnabled = false
        
    }
    
    // Layout Settings
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3 - 1
        
        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    /*
    // Select settings
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.allowsSelection = false
        print("press on \(collectionView.cellForItemAtIndexPath(indexPath))")
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.allowsSelection = true
        print("depress on \(collectionView.cellForItemAtIndexPath(indexPath))")
    }
    
    */
    
    
}

// Methods related to lock the image in the photo album to the lock page
extension PhotoAlbumViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {

        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer{
            
            if let cell = getTheCellOnThePress(longPressGestureRecognizer){
                
                // Change the border to indicate the press action
                cell.layer.borderWidth = 4
                cell.layer.borderColor = UIColor.redColor().CGColor
                
                // Display the message
                displayAlertMessageOn(cell, userMessage: "Lock into the lock page?")
                
            }else{
                print("Not get any cell touched??!!!")
                
            }
        }
        
        return true
    }
    
    // Handle the event after user ends long-presses a cell in the collection view
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            return
        }
        
        if let cell = getTheCellOnThePress(gestureReconizer){
            //print (cell)
            //displayAlertMessageOn(cell, userMessage: "Lock into the lock page?")
        }else{
            print("Could not find index path")
        }
    }
 
    
// --------------------------------------Helper Function----------------------------------
    func getTheCellOnThePress(gestureReconizer: UILongPressGestureRecognizer) -> UICollectionViewCell?{
        
        let position = gestureReconizer.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(position)
        
        if let index = indexPath {
            let cell = self.collectionView.cellForItemAtIndexPath(index)
            return cell
        } else {
            return nil
        }
    }
    
    func displayAlertMessageOn(cell: UICollectionViewCell,userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction) in
            
            // Get the image object
            let imageView = cell.viewWithTag(10) as! UIImageView
            let image = imageView.image
            
            // Store the image object to the lock page
            self.storeImageIntoLock(image!)
            
            // Reset the cell
            self.resetTheCell(cell)
            
            // Delete the cell
            self.imageArray.removeAtIndex(self.imageArray.indexOf(image!)!)
            
            // Reload the data
            self.collectionView.reloadData()
            
        });
        
        let cancelAction = UIAlertAction(title:"cancel", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction) in
            
            self.resetTheCell(cell)
            
        });
        
        myAlert.addAction(okAction);
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func storeImageIntoLock(image:UIImage){
        
        // Nevigation
        let pageViewController = self.parentViewController as! PageViewController
        let _lockViewController = pageViewController.lockViewController as! lockViewController
        
        // put the image into the image array of lockViewController
        _lockViewController.images.append(image)
        
        // Reload the data
        _lockViewController.collectionView.reloadData()
    }
    
    func resetTheCell(cell: UICollectionViewCell){
        cell.layer.borderWidth = 0
    }
}
