//
//  PanelView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class PanelView: UIView {

    class func build() -> PanelView {
        return NSBundle.mainBundle().loadNibNamed("Panel", owner: nil, options: nil)[0] as PanelView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func addImageViewByName(name: String) {
        self.addImageviewOnCenterByName(name)
    }

    func animationDownPlay(superView: UIView, condition: () -> Void) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.frame.origin.y = superView.frame.size.height + (self.frame.origin.y / 2)
        }, completion: {(Bool) -> Void in
            condition()
        })
    }

    func animationRightPlay(superView: UIView, condition: () -> Void) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.frame.origin.x = superView.frame.size.width + (self.frame.origin.x / 2)
            }, completion: {(Bool) -> Void in
                condition()
        })
    }

    func animationLeftPlay(superView: UIView, condition: () -> Void) {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.frame.origin.x -= superView.frame.size.width + (self.frame.origin.x / 2)
            }, completion: {(Bool) -> Void in
                condition()
        })
    }
}
