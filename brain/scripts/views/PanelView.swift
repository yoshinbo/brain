//
//  PanelView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class PanelView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func build() {
        self.backgroundColor = UIColor.blackColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.build()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.build()
    }

}
