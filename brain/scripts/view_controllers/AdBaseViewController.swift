//
//  AdBaseViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2015/01/02.
//  Copyright (c) 2015年 yoshinbo. All rights reserved.
//

import UIKit

class AdBaseViewController: BaseViewController {

    var adBannerView: GADBannerView!
    var isAdbannerVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = adMobUnitID
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        adBannerView.frame = CGRectMake(
            (self.view.bounds.size.width - adBannerView.bounds.size.width) / 2,
            self.view.bounds.size.height - adBannerView.bounds.size.height,
            adBannerView.bounds.size.width,
            adBannerView.bounds.size.height
        )
        adBannerView.loadRequest(GADRequest())
        self.view.addSubview(adBannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        adBannerView.removeFromSuperview()
        adBannerView.delegate = nil
        adBannerView = nil
    }
}

extension AdBaseViewController: GADBannerViewDelegate {
    // For AdMob
    func adViewDidReceiveAd(adView: GADBannerView){
        if isAdbannerVisible == false {
            isAdbannerVisible = true
        }
    }
}
