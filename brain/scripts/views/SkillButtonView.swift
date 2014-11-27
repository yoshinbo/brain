//
//  SkillButtonView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/27.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class SkillButtonView: UIView {
    
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var useCountLabel: UILabel!
    
    class func build() -> SkillButtonView {
        return NSBundle.mainBundle().loadNibNamed("Skill", owner: nil, options: nil)[0] as SkillButtonView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
