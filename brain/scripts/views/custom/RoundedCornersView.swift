//
//  RoundedCornersView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/20.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class RoundedCornersView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.makeCircle()
    }

    func makeCircle() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
