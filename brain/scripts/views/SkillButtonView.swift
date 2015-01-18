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
    var user: User?
    var skill: Skill?
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

    func onTap(recognizer: UITapGestureRecognizer) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            notificationOnTapSkillButton,
            object: nil,
            userInfo: ["skillId": self.skill!.id]
        )
    }

    func checkCapable(energy: Int) {
        if self.isSelected {
            return
        }
        if energy >= self.skill!.cost && self.skill!.isAvailableByUser(self.user!) {
            self.skillNameLabel.textColor = UIColor.whiteColor()
            self.userInteractionEnabled = true
        } else {
            self.skillNameLabel.textColor = UIColor.darkGrayColor()
            self.userInteractionEnabled = false
        }
    }

    func checkOrToggle(skillId: Int, currentEnergy: Int) {
        if skillId == self.skill!.id {
            self.toggleButton()
        } else {
            self.checkCapable(currentEnergy)
        }
    }

    func clearSelect(currentEnergy: Int) {
        self.isSelected = false
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.checkCapable(currentEnergy)
    }

    func setParams(user: User, skill: Skill, energy: Int) {
        self.user = user
        self.skill = skill
        self.skillNameLabel.text = skill.name
        self.descriptionLabel.text = self.getDescriptionLableText()
        self.costLabel.text = NSString(
            format: NSLocalizedString("costFormat", comment: ""),
            skill.cost
        )
        if !skill.isAvailableByUser(user) {
            self.descriptionLabel.textColor = UIColor.darkGrayColor()
            self.costLabel.textColor = UIColor.darkGrayColor()
        }
        self.checkCapable(energy)
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
    private func getDescriptionLableText() -> String {
        return self.skill!.isAvailableByUser(self.user!)
            ? self.skill!.desc
            : NSString(
                format: NSLocalizedString("brainOpenCondition", comment: ""),
                User.getBrainById(self.skill!.requiredBrainId).unnamed
            )
    }

    private func addRecognizer() {
        var recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTap:"))
        self.addGestureRecognizer(recognizer)
    }

    private func makeCircle() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
    }

    private func toggleButton() {
        if self.isSelected {
            self.isSelected = false
            self.layer.borderColor = UIColor.darkGrayColor().CGColor
        } else {
            self.isSelected = true
            self.layer.borderColor = UIColor.orangeColor().CGColor
        }
    }
}
