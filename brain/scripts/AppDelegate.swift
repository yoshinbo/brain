//
//  AppDelegate.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdColonyDelegate {

    var window: UIWindow?
    var tracker: GAITracker?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // AdColony
        AdColony.configureWithAppID(
            "appca317c8cca724ab9ae",
            zoneIDs: ["vz466b9493eb11438fa2"],
            delegate: self,
            logging: true
        )

        // Google Analtytics Settings
        GAI.sharedInstance().trackUncaughtExceptions = true;
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = .Verbose
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58054351-1")
        }

        var (navigationController, topViewController) = TopViewController.build()
        self.showViewController(navigationController)
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

extension AppDelegate {
    func showViewController(viewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = viewController;
        self.window!.makeKeyAndVisible()
    }
}

extension AppDelegate {
    func onAdColonyV4VCReward(success: Bool, currencyName: String!, currencyAmount amount: Int32, inZone zoneID: String!) {
        println("AdColony zone \(zoneID) reward \(success) \(amount) \(currencyName)")
        if success {
            User().recoverEnergy()
        } else {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                let build = GAIDictionaryBuilder.createAppView().set(
                    "brain.failedPlayAdVideo",
                    forKey: kGAIScreenName
                    ).build()
                appDelegate.tracker?.send(build)
            }
        }
    }
}