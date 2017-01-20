//
//  StoryViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/17.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

// --------------------------- Not used any more. Replaced by StoryViewController_TableView -------------------------------
class StoryViewController: UIViewController {

    var scrollView: UIScrollView!
    
    override func viewDidAppear(animated: Bool) {
        
        // Get the reference of the scroll view
        scrollView = self.parentViewController?.view.viewWithTag(10) as! UIScrollView?
    }

// --------------------------- Button Action -------------------------------
    @IBAction func backToCamera(sender: UIBarButtonItem) {
        
        moveToPage(2, scrollView: scrollView)
        
        
    }
    @IBAction func goToDiscovery(sender: UIBarButtonItem) {
        
        moveToPage(4, scrollView: scrollView)
        
    }

// --------------------------- Helper Function -------------------------------
    func moveToPage(number: Int, scrollView: UIScrollView?){
        
        if scrollView != nil {
            
            // Get the frame of scrollView
            var frame: CGRect = self.scrollView.frame
            
            // Set the frame
            frame.origin.x = frame.size.width * CGFloat(number-1);
            frame.origin.y = 0;
            
            // Move to the desired position
            self.scrollView.scrollRectToVisible(frame, animated: true)
            
            
        }else{
            
            // Print the error message
            print("the scroll view object is nil")
            
        }
    }
}
