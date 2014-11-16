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
        var imageView = self.addImageviewOnCenterByName("circle")
        let secLabel: UILabel = UILabel(frame:CGRectZero)
        secLabel.text = NSString(format: "%d",sec)
        secLabel.sizeToFit()
        imageView.addSubviewOnCenter(secLabel)
        self.scaleSmallerThenDismiss(imageView)
    }

    func addOKImageWithBonusRate(bonusCoef:Int) {
        var imageView = self.addImageviewOnCenterByName("ok_fill")
        if (bonusCoef > 1) {
            let bonusCoefLabel: UILabel = UILabel(frame:CGRectZero)
            bonusCoefLabel.text = NSString(format: "x%d",bonusCoef)
            bonusCoefLabel.sizeToFit()
            imageView.addSubview(bonusCoefLabel)
        }
        self.scaleSmallerThenDismiss(imageView)
    }

    func addNGImage() {
        var imageView = self.addImageviewOnCenterByName("ng_fill")
        self.scaleSmallerThenDismiss(imageView)
    }
}

extension InformationView {
    // スケールが1/2になった後に消えるアニメーション
    private func scaleSmallerThenDismiss(view: UIView) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            }, completion: {(Bool) -> Void in
                view.removeFromSuperview()
        })
    }
}
