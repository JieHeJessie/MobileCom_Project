//
//  AppDelegate.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 7/26/14.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set the color of pageController
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageController.backgroundColor = UIColor.blackColor()
        
        // Initialize the data for testing
        Friends.initializeSomeData()
        User.currentUser = User(username:"Ben Liu", cellPhone: "1923123", age: "22")
        shakeShakeMessages.initializeSomeData()
        
        // Initialize the barcode
        let centerImage = UIImage(named: "erha.png")
        let image = QRCodeTool.generatorQRCode(User.currentUser!.username, centerImage: centerImage)
        
        // Initialize the current user
        User.currentUser = User(username: "Ben Liu")
        User.currentUserBarCodeImage = image
        
        // Initialize some addedFriendMessages
        AddedFriendMessages.addedFriendMessages.append(AddedFriendMessage(username: "Hua Hua", time: "10:12"))
        AddedFriendMessages.addedFriendMessages.append(AddedFriendMessage(username: "Jie He", time: "12:12"))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

