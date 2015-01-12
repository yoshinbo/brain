//
//  informationView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/15.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class InformationView: UIView {

    class func build() -> InformationView {
        return NSBundle.mainBundle().loadNibNamed("Information", owner: nil, options: nil)[0] as InformationView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addReadySecImage(sec:Int) {
        var imageView = self.addImageviewOnCenterByName("count_\(sec)")
        self.scaleBiggerThenDismiss(imageView)
    }

    func addOKImageWithBonusRate(bonusCoef:Int) {
        var imageView: UIView!
        if (bonusCoef > 1) {
            imageView = self.addImageviewOnCenterByName("ok_\(bonusCoef)")
        } else {
            imageView = self.addImageviewOnCenterByName("ok_fill")
        }
        self.scaleBiggerSmallerThenDismiss(imageView)
    }

    func addNGImage() {
        var imageView = self.addImageviewOnCenterByName("ng_fill")
        self.scaleBiggerSmallerThenDismiss(imageView)
    }
}

extension InformationView {
    // スケールが1/2から1になった後に消えるアニメーション
    private func scaleBiggerThenDismiss(view: UIView) {
        view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        UIView.animateWithDuration(0.7,
            animations: {
                () -> Void in
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            },
            completion: {
                (Bool) -> Void in
                view.removeFromSuperview()
        })
    }

    // スケールが大きくなった後に小さくなって消えるアニメーション
    private func scaleBiggerSmallerThenDismiss(view: UIView) {
        view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        UIView.animateWithDuration(0.3,
            animations: {
                () -> Void in
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            },
            completion: {
                (Bool) -> Void in
        UIView.animateWithDuration(0.2,
            animations: {
                () -> Void in
                view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            },
            completion: {
                (Bool) -> Void in
                view.removeFromSuperview()
        }) })
    }
}
