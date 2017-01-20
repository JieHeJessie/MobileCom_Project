//
//  PageViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/29.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
        
    // Three nested view controllers in the scrollView
    var snapViewController: UIViewController!
    var photoAlbumViewController: UIViewController!
    var lockViewController: UIViewController!
    
    var orderdViewControllers: [UIViewController] = [UIViewController]()
    
    var memoryViewController: UpdatedMemoryViewController!
    var pageNameLabel: UILabel!
    
    var destinationViewController: UIViewController!
    
    override func viewDidLoad() {
        
        // Get the reference of the memory storyBoard
        let memoryStoryBoard = UIStoryboard(name: "memory", bundle: nil)
        let photoAlbumStoryBoard = UIStoryboard(name: "photoAlbum", bundle: nil)
        
        // Initialize the nested view controllers
        snapViewController = memoryStoryBoard.instantiateViewControllerWithIdentifier("Snap")
        photoAlbumViewController = photoAlbumStoryBoard.instantiateViewControllerWithIdentifier("photoAlbum")
        lockViewController = memoryStoryBoard.instantiateViewControllerWithIdentifier("Lock")
        
        orderdViewControllers.append(snapViewController)
        orderdViewControllers.append(photoAlbumViewController)
        orderdViewControllers.append(lockViewController)
        
        // Set the first view controller in the pageView controller
        self.setViewControllers([orderdViewControllers[0]], direction: .Forward, animated: true, completion: nil)
        
        dataSource = self
        delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Get the reference of the pageNameLabel in the memory viewController
        let MemoryViewController = self.parentViewController as! UpdatedMemoryViewController
        pageNameLabel = MemoryViewController.pageNameLabel

    }
    
// --------------------------- pageViewController -------------------------------
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        var index = orderdViewControllers.indexOf(viewController)!
        
        if (index == 0 || index == NSNotFound){
            
            return nil
            
        }
        
        index = index - 1
        
        return self.orderdViewControllers[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        var index = orderdViewControllers.indexOf(viewController)!

        if (index == NSNotFound){
            
            return nil
            
        }

        index = index + 1

        if (index == self.orderdViewControllers.count){
            
            return nil
            
        }

        return self.orderdViewControllers[index]
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.orderdViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed == true){
            
        // Get the index of destination view controller
        let destinationIndex = orderdViewControllers.indexOf(destinationViewController)
        
        // Update the label of the text
        switch destinationIndex! {
        case 0:
            pageNameLabel.text = "Snap"
        case 1:
            pageNameLabel.text = "Photo Album"
        case 2:
            pageNameLabel.text = "Lock"
        default:
            print ("No index is matched")
        }
            
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        destinationViewController = pendingViewControllers.last!
    }
}
