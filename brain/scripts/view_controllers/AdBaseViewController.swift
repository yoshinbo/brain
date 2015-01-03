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
    var adIconViews: [NADIconView] = []
    var adIconLoader: NADIconLoader!
    var isAdbannerVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = adMobUnitId
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

        // Nend Icon Ad
        var adIconNum = 4
        var icon_width = 75
        var icon_height = 75;
        var margin = Int(self.view.bounds.width) / adIconNum - icon_width
        var offset = margin / 2

        adIconLoader = NADIconLoader()
        adIconLoader.isOutputLog = true

        for (var i = 0; i < adIconNum ; i++) {
            var iconFrame = CGRect(
                x: offset + (icon_width + margin) * i,
                y: Int(self.view.bounds.height) - icon_height + margin,
                width: icon_width,
                height: icon_height
            )
            var iconView = NADIconView(frame: iconFrame)
            self.view.addSubview(iconView)
            adIconLoader.addIconView(iconView)
            adIconViews.append(iconView)
        }

        adIconLoader.setNendID(nendApiKey, spotID: nendSpotId)
        adIconLoader.delegate = self
        adIconLoader.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        adBannerView.removeFromSuperview()
        adBannerView.delegate = nil
        adBannerView = nil

        for iconView in adIconViews {
            adIconLoader.removeIconView(iconView)
            iconView.removeFromSuperview()
        }
        adIconViews.removeAll(keepCapacity: false)
        adIconLoader.delegate = nil
        adIconLoader = nil
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

extension AdBaseViewController: NADIconLoaderDelegate {
    func nadIconLoaderDidFinishLoad(iconLoader: NADIconLoader!) {
        println("success")
    }
}
