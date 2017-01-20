//
//  StoryViewController_TableView.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/8.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

enum Section: Int {
    case Story = 0
    case Collection = 1
    case Subcription = 2
}

class StoryViewController_TableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let travelPublishers: [Publisher] = Travel.publishers()
    let politicsPublishers: [Publisher] = Politics.publishers()
    let technologyPublishers: [Publisher] = Technology.publishers()
    
    var storiesInMessageCell: [StoryMessage] = []
    var magazinesInCollectionView: [Magazine] = []
    var magazinesInSubcriptionCell: [Magazine] = []
    
    var filteredMagazines: [Magazine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Message Content For testing
        storiesInMessageCell = StoryMessages.storyMessages
        
        // Collection View content
        let wholePublishers = travelPublishers + politicsPublishers + technologyPublishers
        for publisher in wholePublishers{
            
            let description = "\(publisher.section): \(publisher.title)"
            let magazine = Magazine(publisher: publisher, description: description)
            
            magazinesInCollectionView.append(magazine)
        }

        // Add function "pull to fresh" to the table view
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.8)
        refreshControl.addTarget(self, action: #selector(StoryViewController_TableView.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Store self to the StoryMessages data source
        StoryMessages.tableViewInTheStory = self
    }
}

// --------------------------- Table View -------------------------------
extension StoryViewController_TableView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){

            return 1
        }
        
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            return nil
        }
        
        switch section {
        case Section.Story.rawValue:
            return "Story Message"
        case Section.Collection.rawValue:
            return "Magazines"
        case Section.Subcription.rawValue:
            return "Subcription"
        default:
            NSLog("Unknown section")
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){

            return filteredMagazines.count
        }
        
        switch section {
        case Section.Story.rawValue:
            return storiesInMessageCell.count
        case Section.Collection.rawValue:
            return 1
        case Section.Subcription.rawValue:
            return magazinesInSubcriptionCell.count
        default:
            NSLog("Unknown section")
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            
            let tableViewCell = self.tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
            
            let magazine = filteredMagazines[indexPath.row]
            tableViewCell.setImageWith(magazine.publisher.image, content: magazine.description!, optionLabel: magazine.publisher.section)
            
            return tableViewCell
        }
        
        switch indexPath.section{
        case Section.Story.rawValue:
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
            
            // Get the selected story
            let story = storiesInMessageCell[indexPath.row]
            
            // Set the content of the cell
            if let sender = story.sender?.username {
                tableViewCell.setImageWith(story.image, content: story.content, optionLabel: "Time: \(story.receivingTime)  Sender: \(sender)")
            }else {
                tableViewCell.setImageWith(story.image, content: story.content, optionLabel: "Time: \(story.receivingTime)")
            }
            
            
            // Set the arrow
            tableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return tableViewCell
        case Section.Collection.rawValue:
            
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier("StoryCollectionCell") as! StoryCollectionCell
            tableViewCell.setCollectionViewRelatedDelegate(self)
            
            return tableViewCell
        case Section.Subcription.rawValue:
            
            let tableViewCell = tableView.dequeueReusableCellWithIdentifier("SubcriptionCell") as! SubcriptionCell
            
            let subcription = magazinesInSubcriptionCell[indexPath.row]
            
            tableViewCell.setImageWith(subcription.publisher.image, content: subcription.description!, optionLabel: subcription.publisher.section)
            tableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return tableViewCell
        default:
            NSLog("Unknown section")
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            return 80
        }
        
        switch indexPath.section{
        case Section.Story.rawValue:
            return 80
        case Section.Collection.rawValue:
            return 150
        case Section.Subcription.rawValue:
            return 80
        default:
            NSLog("Unknown section")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section{
        case Section.Collection.rawValue:
            ()
        case Section.Story.rawValue:
            let storyMessage:StoryMessage = storiesInMessageCell[indexPath.row]
            
            performSegueWithIdentifier("goToReview", sender: storyMessage)
            
        case Section.Subcription.rawValue:
            
            let magazine:Magazine = magazinesInSubcriptionCell[indexPath.row]
            
            // Navigation
            let snapContainerViewController = navigationController?.parentViewController as! SnapContainerViewController
            let discoveryContainerViewController = snapContainerViewController.rightMostVc.childViewControllers[0] as! PublishersCollectionViewController
            
            // Update the click on this magazine
            discoveryContainerViewController.addClicksTo(magazine.publisher)
            // Refresh
            discoveryContainerViewController.updateContentsBasedOnClicks()
            
            performSegueWithIdentifier("showWebView", sender: magazine)
        default:
            // The section for the search bar
            NSLog("Search Section")
            
            let magazine:Magazine = filteredMagazines[indexPath.row]
            performSegueWithIdentifier("showWebView", sender: magazine)
        }
        
    }
    
// ------------------------------ Helper function --------------------------------------
    func refresh (sender: UIRefreshControl){
        
        tableView.reloadData()
        sender.endRefreshing()
    
    }
    
// --------------------------- Segue Preparation -------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showWebView"){
        
            let destination = segue.destinationViewController as! WebViewController
            let magazine = sender as! Magazine
            destination.publisher = magazine.publisher
        }else if (segue.identifier == "goToReview"){
            let destination = segue.destinationViewController
            let storyMessage = sender as! StoryMessage
            
            // Get the image view of the destination
            let imageView = destination.view.viewWithTag(100) as! UIImageView
            
            // Set the picture
            if let image = storyMessage.image{
                imageView.image = image
            }
        
        }
    }
// ------------------------------ button action --------------------------------------
    @IBAction func backToCamera(sender: UIBarButtonItem) {
        let horizontalContainer = self.navigationController?.parentViewController as!  SnapContainerViewController
        
        let scrollView = horizontalContainer.scrollView
        let widthOfAnyViewController = self.view.frame.width
        
        scrollView.setContentOffset(CGPoint(x:widthOfAnyViewController,y:0), animated: true)
        
    }
    
    @IBAction func goToDiscovery(sender: UIBarButtonItem) {
        let horizontalContainer = self.navigationController?.parentViewController as!  SnapContainerViewController
        let scrollView = horizontalContainer.scrollView
        
        let widthOfAnyViewController = self.view.frame.width
        
        scrollView.setContentOffset(CGPoint(x:widthOfAnyViewController*3,y:0), animated: true)
    }

}

// --------------------------- Collection View -------------------------------
extension StoryViewController_TableView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return magazinesInCollectionView.count
    }
    
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let imageCell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath)
        let imageView = imageCell.viewWithTag(10) as! UIImageView
        
        let image = magazinesInCollectionView[indexPath.row].publisher.image
        imageView.image = image
        
        return imageCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let clickEffectView = cell?.viewWithTag(20)
        
        clickEffectView!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        UIView.animateWithDuration(0.8, animations: {
        
        clickEffectView!.backgroundColor = UIColor.clearColor()
        
        })
        
        let magazine = magazinesInCollectionView[indexPath.row]
        
        //MARK: Update the click
        // Navigation
        let snapContainerViewController = navigationController?.parentViewController as! SnapContainerViewController
        let discoveryContainerViewController = snapContainerViewController.rightMostVc.childViewControllers[0] as! PublishersCollectionViewController
        
        // Update the click on this magazine
        discoveryContainerViewController.addClicksTo(magazine.publisher)
        // Refresh
        discoveryContainerViewController.updateContentsBasedOnClicks()
        
        performSegueWithIdentifier("showWebView", sender: magazine)
        
    }
}

// --------------------------- Search Bar -------------------------------
extension StoryViewController_TableView: UISearchBarDelegate, UISearchDisplayDelegate{

    func filterContentForSearchText (searchText: String, scope: String = "Magazine"){
        self.filteredMagazines = self.magazinesInCollectionView.filter({
            (magazine: Magazine) -> Bool in
            
            let catergoryMatch = (scope == "Magazine")
            let stringMatch = magazine.description!.rangeOfString(searchText)
            
            return catergoryMatch && (stringMatch != nil)
        
        
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText((self.searchDisplayController?.searchBar.text)!, scope: "Magazine")
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!, scope: "Magazine")
        return true
    }
}