//
//  ExpGaugeView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/17.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class ExpGaugeView: UIView {

    @IBOutlet weak var gaugeView: UIView!
    @IBOutlet weak var gaugeConstraint: NSLayoutConstraint!
    var originalGaugeWidth: CGFloat = 0.0
    var beforeExpRatePercentage: Int = 0
    var afterExpRatePercentage: Int = 0
    var levelUpNum: Int = 0

    class func build() -> ExpGaugeView {
        return NSBundle.mainBundle().loadNibNamed("ExpGauge", owner: nil, options: nil)[0] as ExpGaugeView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setParam(expRatePercentage: Int) {
        self.gaugeConstraint.constant = self.constantWidth(expRatePercentage)
        self.gaugeView.layoutIfNeeded()
    }

    func setParamWithAnimation(beforeExpRatePercentage: Int, afterExpRatePercentage: Int, levelUpNum: Int) {
        self.originalGaugeWidth = self.gaugeView.bounds.width
        self.beforeExpRatePercentage = beforeExpRatePercentage
        self.afterExpRatePercentage = afterExpRatePercentage
        self.levelUpNum = levelUpNum
        self.animation()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension ExpGaugeView {
    private func animation() {
        self.gaugeConstraint.constant = self.constantWidth(self.beforeExpRatePercentage)
        self.gaugeView.layoutIfNeeded()
        if levelUpNum > 0 {
            self.gaugeConstraint.constant = 0
        } else {
            self.gaugeConstraint.constant = self.constantWidth(self.afterExpRatePercentage)
            self.afterExpRatePercentage = 0
        }
        UIView.animateWithDuration(1.5,
            animations: {() -> Void in
                self.gaugeView.layoutIfNeeded()
            },
            completion: {(Bool) -> Void in
                self.beforeExpRatePercentage = 0
                self.levelUpNum -= 1
                if self.afterExpRatePercentage != 0 {
                    self.animation()
                }
            }
        )
    }
    private func constantWidth(expRatePercentage: Int) -> CGFloat {
        var rate = Util.conevertExpRatePercentageToRate(expRatePercentage)
        return CGFloat(Int(Float(self.originalGaugeWidth) * (1 - rate)))
    }
}
