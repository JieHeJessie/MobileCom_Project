//
//  PublishersCollectionViewController.swift
//  News
//
//  Created by HEJIE on 28/09/2016.
//  Copyright © 2016 Developer Inspirus. All rights reserved.
//

import UIKit

class PublishersCollectionViewController: UICollectionViewController{
    
    // data source
    let publishers = Publishers()
    //设置左边边和右边边的距离
    private let leftAndRightPaddings: CGFloat = 32.0
    // 3 items per row
    private let numberOfItemsPerRow: CGFloat = 3.0
    //
    private let heightAdjustment: CGFloat = 30.0
    
    // MARK: Discovery algorithm
    // The click dictionary
    var clicksOfSections: [String: Int] = ["Politics":0,"Travel":0,"Technology":0]
    var clicksOfPoliticsItems: [Publisher: Int] = [Publisher: Int]()
    var clicksOfTravelItems: [Publisher: Int] = [Publisher: Int]()
    var clicksOfTechnologyItems: [Publisher: Int] = [Publisher: Int]()
    
    // Addition correction for not preserving order of dictionary
    var mostRecentClickPublisher:Publisher! = nil
    var mostRecentClickPublisherSection:String! = nil
    
    //MARK: -View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //宽度＝(总的iPhone界面的宽度－之前设置左右两边的宽度)／item个数
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPaddings) / numberOfItemsPerRow
        
        //设置layout (设置每个item之间的布局)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width+heightAdjustment)
        
        // Add a button item
        let leftBarButton = UIBarButtonItem(title: "Story", style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(backToStory))
        navigationItem.setLeftBarButtonItem(leftBarButton, animated: true)
        
        //MARK: discovery algorithm logic
        self.initializeClicksOfAllItems()
        
        //MARK: long press to store magazine into subcription list in the story
        // Add a long press gesture recognizer to the collection view(working on the cell)
        let lpgr = UILongPressGestureRecognizer(target: self, action: nil)
        lpgr.minimumPressDuration = 0.3
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Update the collection items based on previous click events
        updateContentsBasedOnClicks()
    }
    
// --------------------------- Button Action -------------------------------
    func backToStory(sender: UIBarButtonItem){
        let horizontalContainer = self.navigationController?.parentViewController as! SnapContainerViewController
        
        horizontalContainer.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 2,y:0), animated: true)
    }
    
// --------------------------- Collection View -------------------------------
    // how many sections
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //number of items/cells in section
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publishers.numberOfPublishers
        
    }
    
    private struct Storyboard{
        static let CellIdentifier = "PublisherCell"
        static let showWebView = "ShowWebView"
    }
    
    //cells for item at index path
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! PublishersCollectionViewCell
        
        cell.publisher = publishers.publisherForItemAtIndexPath(indexPath)
        
        return cell
    }
    //MARK: -UICollectionViewDelegate(用户点击item)
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let publisher = publishers.publisherForItemAtIndexPath(indexPath)
        
        // Add number of clicks to the item
        self.addClicksTo(publisher!)

        // Perform the segue to the web view controller
        self.performSegueWithIdentifier(Storyboard.showWebView, sender: publisher)
    }

// --------------------------- Segue preparation -------------------------------
    // Send the publisher object before performing the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let publisher = sender as! Publisher
        let destination = segue.destinationViewController as! WebViewController
        
        destination.publisher = publisher
        
    }
    
}

// --------------------------- Discovery algorithm logic -------------------------------
extension PublishersCollectionViewController{
    
    func initializeClicksOfAllItems(){
        for (index, publisher) in publishers.publishers.enumerate(){
            switch index {
            case 0...5:
                clicksOfPoliticsItems[publisher] = 0
            case 6...11:
                clicksOfTravelItems[publisher] = 0
            case 12...16:
                clicksOfTechnologyItems[publisher] = 0
            default:
                NSLog("Unknown publisher index")
            }
        }
    }
    
    func addClicksTo(publisher: Publisher){
        let section = publisher.section
        switch section {
        case "Politics":
            clicksOfPoliticsItems[publisher]! += 1
            clicksOfSections["Politics"]! += 1
        case "Travel":
            clicksOfTravelItems[publisher]! += 1
            clicksOfSections["Travel"]! += 1
        case "Technology":
            clicksOfTechnologyItems[publisher]! += 1
            clicksOfSections["Technology"]! += 1
        default:
            NSLog("Unknown section- AddClicksTo method")
        }
        
        //Addition correction for not preserving order of dictionary
        self.mostRecentClickPublisher = publisher
        self.mostRecentClickPublisherSection = publisher.section
    }
    
    func updateContentsBasedOnClicks(){
        // Get the sections
        var sections = Array(clicksOfSections.keys)
        
        //Addition correction for not preserving order of dictionary
        if (mostRecentClickPublisherSection != nil){
            let position = sections.indexOf(self.mostRecentClickPublisherSection)
            sections.removeAtIndex(position!)
            sections.insert(mostRecentClickPublisherSection, atIndex: 0)
        }
        //print("original \(sections)")
        
        // Sort the section array to get the topic from most clicks to least clicks
        let sortedSections = sections.sort({self.clicksOfSections[$0] > self.clicksOfSections[$1]})
        //print ("sorted \(sortedSections)")
        
        // Reset the publisher data source
        publishers.reset()
        
        for section in sortedSections{
            switch section {
            case "Politics":
                var politicsKeys:[Publisher] = [Publisher](clicksOfPoliticsItems.keys)
                
                // //Addition correction for not preserving order of dictionary
                if (mostRecentClickPublisher?.section == "Politics"){
                    let position = politicsKeys.indexOf(mostRecentClickPublisher)
                    
                    politicsKeys.removeAtIndex(position!)
                    politicsKeys.insert(mostRecentClickPublisher, atIndex: 0)
                }
                
                let sortedPoliticsKeys = politicsKeys.sort({self.clicksOfPoliticsItems[$0]! > self.clicksOfPoliticsItems[$1]!})
                self.publishers.appendWithArray(sortedPoliticsKeys)
            case "Travel":
                var travelsKeys:[Publisher] = [Publisher](clicksOfTravelItems.keys)
                
                // //Addition correction for not preserving order of dictionary
                if (mostRecentClickPublisher?.section == "Travel"){
                    let position = travelsKeys.indexOf(mostRecentClickPublisher)
                    
                    travelsKeys.removeAtIndex(position!)
                    travelsKeys.insert(mostRecentClickPublisher, atIndex: 0)
                }
                
                let sortedTravelKeys = travelsKeys.sort({self.clicksOfTravelItems[$0]! > self.clicksOfTravelItems[$1]!})
                self.publishers.appendWithArray(sortedTravelKeys)
            case "Technology":
                var techKeys:[Publisher] = [Publisher](clicksOfTechnologyItems.keys)
                
                // //Addition correction for not preserving order of dictionary
                if (mostRecentClickPublisher?.section == "Technology"){
                    let position = techKeys.indexOf(mostRecentClickPublisher)
                    
                    techKeys.removeAtIndex(position!)
                    techKeys.insert(mostRecentClickPublisher, atIndex: 0)
                }
                
                let sortedTecKeys = techKeys.sort({self.clicksOfTechnologyItems[$0]! > self.clicksOfTechnologyItems[$1]!})
                self.publishers.appendWithArray(sortedTecKeys)
            default:
                NSLog("Unknown section- updateContentsBasedOnClicks method")
            }
        }
        
        // Reload the data
        self.collectionView?.reloadData()
    }
}

// --------------------------- long press to store into subcription list in the story -------------------------------
extension PublishersCollectionViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer{
            
            if let cell = getTheCellOnThePress(longPressGestureRecognizer){
                
                // Change the border to indicate the press action
                cell.layer.borderWidth = 4
                cell.layer.borderColor = UIColor.redColor().CGColor
                
                // Display the message
                displayAlertMessageOn(cell, userMessage: "Subcript this magazine?")
                
            }else{
                print("Not get any cell touched??!!!")
                
            }
        }
        
        return true
    }
    
    func displayAlertMessageOn(cell: PublishersCollectionViewCell,userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction) in
            
            // Get the publisher object
            let newPublisher = cell.publisher!
            
            // Create the new magazine object
            let magazine = Magazine(publisher: newPublisher, description: "\(newPublisher.section): \(newPublisher.title)")

            // Store the new magazine subcription
            self.storeMagazineIntoStory(magazine)
            
            // Reset the cell
            self.resetTheCell(cell)
            
        });
        
        let cancelAction = UIAlertAction(title:"cancel", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction) in
            
            self.resetTheCell(cell)
            
        });
        
        myAlert.addAction(okAction);
        myAlert.addAction(cancelAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func getTheCellOnThePress(gestureReconizer: UILongPressGestureRecognizer) -> PublishersCollectionViewCell?{
        
        let position = gestureReconizer.locationInView(self.collectionView)
        let indexPath = self.collectionView?.indexPathForItemAtPoint(position)
        
        if let index = indexPath {
            let cell = self.collectionView?.cellForItemAtIndexPath(index) as? PublishersCollectionViewCell
            return cell
        } else {
            return nil
        }
    }
    
    func storeMagazineIntoStory(magazine:Magazine){
        
        // Nevigation
        let horizontalContainer = self.navigationController?.parentViewController as! SnapContainerViewController
        let storyNavigationViewController = horizontalContainer.rightVc as! UINavigationController
        let storyViewController = storyNavigationViewController.childViewControllers[0] as! StoryViewController_TableView
        
        // put the new Magazine into subcription list
        storyViewController.magazinesInSubcriptionCell.append(magazine)

        // Reload the data
        storyViewController.tableView.reloadData()
    }
    
    func resetTheCell(cell: UICollectionViewCell){
        cell.layer.borderWidth = 0
    }
}

