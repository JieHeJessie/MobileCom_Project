//
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var rightMostVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    // Set the settings
    func setVcAndOthers (leftVC: UIViewController,
                         middleVC: UIViewController,
                         rightVC: UIViewController,
                         rightMostVC: UIViewController,
                         topVC: UIViewController?=nil,
                         bottomVC: UIViewController?=nil,
                         directionLockDisabled: Bool?=false){
        
        self.directionLockDisabled = directionLockDisabled
        
        self.topVc = topVC
        self.leftVc = leftVC
        self.middleVc = middleVC
        self.rightVc = rightVC
        self.bottomVc = bottomVC
        self.rightMostVc = rightMostVC

    }
    
    class func containerViewWithLeftVC(leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 rightMostVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        container.rightMostVc = rightMostVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the view controller components
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discoveryStoryBoard = UIStoryboard(name: "Discovery", bundle: nil)
        let storyStoryBoard = UIStoryboard(name: "Story", bundle: nil)
        let userStoryBoard = UIStoryboard(name: "User", bundle: nil)
        
        let left = storyboard.instantiateViewControllerWithIdentifier("left")
        let middle = storyboard.instantiateViewControllerWithIdentifier("middle")
        
        //let right = storyboard.instantiateViewControllerWithIdentifier("right")
        let right = storyStoryBoard.instantiateViewControllerWithIdentifier("storyNavigationController")
        
        //let rightMost = storyboard.instantiateViewControllerWithIdentifier("rightMost")
        let rightMost = discoveryStoryBoard.instantiateViewControllerWithIdentifier("NavigationViewController")
        
        //let top = storyboard.instantiateViewControllerWithIdentifier("top")
        let top = userStoryBoard.instantiateViewControllerWithIdentifier("userNavigationViewController")
        
        let bottom = storyboard.instantiateViewControllerWithIdentifier("bottom")
        
        // Set the settings
        self.setVcAndOthers(left, middleVC: middle, rightVC: right, rightMostVC: rightMost,bottomVC: bottom, topVC: top)
        
        // Setup the scrollView
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc,
                                                                               topVc: topVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        // Set the identifier
        scrollView.tag = 10
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 4 * view.width
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        rightMostVc.view.frame = CGRect(x: 3 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        addChildViewController(rightMostVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        scrollView.addSubview(rightMostVc.view)
        
        leftVc.didMoveToParentViewController(self)
        middleVertScrollVc.didMoveToParentViewController(self)
        rightVc.didMoveToParentViewController(self)
        rightMostVc.didMoveToParentViewController(self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //print ("scrollViewWillBeginDragging")
        self.initialContentOffset = scrollView.contentOffset
        //print (self.initialContentOffset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print (delegate)
        //print (delegate!.outerScrollViewShouldScroll())
        //print (directionLockDisabled)
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
        }
    }
    
}
