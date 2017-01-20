//
//  MemoryViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/9/29.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class UpdatedMemoryViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var nevigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the pageViewController
        let memoryStoryBoard = UIStoryboard(name: "memory", bundle: nil)
        
        // Get the pageViewController
        pageViewController = memoryStoryBoard.instantiateViewControllerWithIdentifier("pageViewController") as! PageViewController
        
        self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64)
        
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        // Make the pageNamelabel be the most front view in the layer stack
        self.view.bringSubviewToFront(pageNameLabel)
        pageViewController.didMoveToParentViewController(self)

    }
    
    // MARK: button action
    @IBAction func backToCamera(sender: UIBarButtonItem) {
        let verticalContainer = self.parentViewController as! VerticalScrollViewController
        
        verticalContainer.scrollView.setContentOffset(CGPoint(x:0,y:self.view.frame.height * 1), animated: true)
        
    }
}
