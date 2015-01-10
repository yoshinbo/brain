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

    var window: UIWindow!
    var tracker: GAITracker?
    var adBannerView: GADBannerView!

    var adIconViews: [NADIconView] = []
    var adIconLoader: NADIconLoader!
    var isAdMobBannerVisible: Bool = false
    var isNendBannerVisible: Bool = false
    var isAdMobBannerAdded: Bool = false
    var isNendBannerAdded: Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var (navigationController, topViewController) = TopViewController.build()
        self.showViewController(navigationController)

        self.initTracker()
        self.initAdColony()
        self.initAdMob(topViewController)
        self.initNendIcon()

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

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        // Dispose of any resources that can be recreated.
//        if (adBannerView != nil) {
//            adBannerView.removeFromSuperview()
//            adBannerView.delegate = nil
//            adBannerView = nil
//        }
//
//        if (adIconLoader != nil) {
//            for iconView in adIconViews {
//                adIconLoader.removeIconView(iconView)
//                iconView.removeFromSuperview()
//            }
//            adIconViews.removeAll(keepCapacity: false)
//            adIconLoader.delegate = nil
//            adIconLoader = nil
//        }
    }
}

extension AppDelegate {
    func showViewController(viewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = viewController;
        self.window!.makeKeyAndVisible()
    }

    func isJapaneseLang() -> Bool {
        var languages: [AnyObject] = NSLocale.preferredLanguages()
        var currentLanguage = languages[0] as String
        return currentLanguage == "ja"
    }

    // for Google Analtytics
    func initTracker() {
        GAI.sharedInstance().trackUncaughtExceptions = true;
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = .Verbose
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.tracker = GAI.sharedInstance().trackerWithTrackingId(gaTrackingId)
        }
    }

    // for Footer AD
    func setAdForViewController(viewController: UIViewController) {
        if isNendBannerVisible && isJapaneseLang() {
            for iconView in adIconViews {
                viewController.view.addSubview(iconView)
                isNendBannerAdded = true
            }
        } else if isAdMobBannerVisible {
            viewController.view.addSubview(adBannerView)
            isAdMobBannerAdded = true
        }
    }

    // for AdColony
    func initAdColony() {
        AdColony.configureWithAppID(
            adColonyAppId,
            zoneIDs: [adColonyZoneId],
            delegate: self,
            logging: true
        )
    }

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

extension AppDelegate: GADBannerViewDelegate {

    func initAdMob(viewController: UIViewController) {
        isAdMobBannerVisible = false
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = adMobUnitId
        adBannerView.rootViewController = viewController
        adBannerView.delegate = self
        adBannerView.frame = CGRectMake(
            (self.window.bounds.size.width - adBannerView.bounds.size.width) / 2,
            self.window.bounds.size.height - adBannerView.bounds.size.height,
            adBannerView.bounds.size.width,
            adBannerView.bounds.size.height
        )
        adBannerView.loadRequest(GADRequest())
    }

    func adViewDidReceiveAd(adView: GADBannerView){
        if isAdMobBannerVisible == false {
            isAdMobBannerVisible = true
            NSNotificationCenter.defaultCenter().postNotificationName(
                notificationLoadedAd,
                object: nil
            )
            println("AdMobBanner is OK")
        }
    }

    func adView(adView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        println("AdMobBanner is NG")
    }
}

extension AppDelegate: NADIconLoaderDelegate {

    func initNendIcon() {
        isNendBannerVisible = false
        var icon_width = Int(adBannerView.bounds.size.height)
        var icon_height = Int(adBannerView.bounds.size.height)
        var adIconNum = min(Int(self.window.bounds.width) / icon_width, 5)
        var margin = Int(self.window.bounds.width) / adIconNum - icon_width
        var offset = margin / 2

        adIconLoader = NADIconLoader()
        adIconLoader.isOutputLog = true

        for (var i = 0; i < adIconNum ; i++) {
            var iconFrame = CGRect(
                x: offset + (icon_width + margin) * i,
                y: Int(self.window.bounds.height) - icon_height,
                width: icon_width,
                height: icon_height
            )
            var iconView = NADIconView(frame: iconFrame)
            adIconLoader.addIconView(iconView)
            adIconViews.append(iconView)
        }

        adIconLoader.setNendID(nendApiKey, spotID: nendSpotId)
        adIconLoader.delegate = self
        adIconLoader.load()
    }

    func nadIconLoaderDidFinishLoad(iconLoader: NADIconLoader!) {
        if isNendBannerVisible == false {
            isNendBannerVisible = true
            NSNotificationCenter.defaultCenter().postNotificationName(
                notificationLoadedAd,
                object: nil
            )
            println("NendBanner is OK")
        }
    }

    func nadIconLoaderDidFailToReceiveAd(iconLoader: NADIconLoader!, nadIconView: AnyObject!) {
        isNendBannerVisible = false
        println("NendBanner is NG")
    }
}
