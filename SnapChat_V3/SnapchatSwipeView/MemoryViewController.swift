//
//  MemoryViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/29.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

// --------------------------- Not used any more, replaced by UpdatedMemoryViewController.swift -------------------------------
class MemoryViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Three nested view controllers in the scrollView
    var snapViewController: UIViewController!
    var photoAlbumViewController: UIViewController!
    var lockViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the reference of the memory storyBoard
        let memoryStoryBoard = UIStoryboard(name: "memory", bundle: nil)
        let photoAlbumStoryBoard = UIStoryboard(name: "photoAlbum", bundle: nil)
        
        // Initialize the nested view controllers
        snapViewController = memoryStoryBoard.instantiateViewControllerWithIdentifier("Snap")
        photoAlbumViewController = photoAlbumStoryBoard.instantiateViewControllerWithIdentifier("photoAlbum")
        lockViewController = memoryStoryBoard.instantiateViewControllerWithIdentifier("Lock")
        
        // Get the width and height of the scroll view content
        let scrollWidth  = 3 * self.view.bounds.width
        let scrollHeight  = self.view.bounds.height
        
        // Set the content size of the scroll view
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        // Set the positon of each nested view controller in the scroll view
        snapViewController.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: self.view.frame.width,
                                   height: self.view.frame.height
        )
        photoAlbumViewController.view.frame = CGRect(x: 1 * self.view.frame.width,
                                               y: 0,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height
        )
        lockViewController.view.frame = CGRect(x: 2 * self.view.frame.width,
                                               y: 0,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height
        )
        
        addChildViewController(snapViewController)
        addChildViewController(photoAlbumViewController)
        addChildViewController(lockViewController)
        
        scrollView.addSubview(snapViewController.view)
        scrollView.addSubview(photoAlbumViewController.view)
        scrollView.addSubview(lockViewController.view)
        
        snapViewController.didMoveToParentViewController(self)
        photoAlbumViewController.didMoveToParentViewController(self)
        lockViewController.didMoveToParentViewController(self)
        
        scrollView.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let parentViewController = self.parentViewController as! VerticalScrollViewController
        let parentScrollView = parentViewController.scrollView
        
        let offset = parentScrollView.contentOffset
        
        if (offset.y == 2 * self.view.frame.height){
            
            parentScrollView.scrollEnabled = false
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }

}
