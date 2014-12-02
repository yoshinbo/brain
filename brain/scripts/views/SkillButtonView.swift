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
    var skill: Skill?
    var user: User?
    var isSelected: Bool = false

    class func build() -> SkillButtonView {
        return NSBundle.mainBundle().loadNibNamed("Skill", owner: nil, options: nil)[0] as SkillButtonView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addRecognizer()
        self.makeCircle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addRecognizer()
        self.makeCircle()
    }

    func makeCircle() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    func toggleButton(recognizer: UITapGestureRecognizer) {
        if self.isSelected {
            self.isSelected = false
            self.layer.borderColor = UIColor.orangeColor().CGColor
        } else {
            self.isSelected = true
            self.layer.borderColor = UIColor.darkGrayColor().CGColor
        }
    }

    func addRecognizer() {
        var recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("toggleButton:"))
        self.addGestureRecognizer(recognizer)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension SkillButtonView {
    func setParams(skill: Skill, user: User) {
        self.user = user
        self.skill = skill
        self.skillNameLabel.text = skill.name
        self.descriptionLabel.text = skill.desc
        self.costLabel.text = NSString(
            format: NSLocalizedString("costFormat", comment: ""),
            skill.cost
        )
    }
}
