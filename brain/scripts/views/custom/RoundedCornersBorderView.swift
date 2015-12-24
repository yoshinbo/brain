//
//  RoundedCornersBorderView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/22.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class RoundedCornersBorderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.makeCircle()
    }
    
    func makeCircle() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blackColor().CGColor
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
