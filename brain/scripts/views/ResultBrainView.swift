//
//  ResultBrainView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/10.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class ResultBrainView: UIView {

    @IBOutlet weak var brainNameLabel: UILabel!
    @IBOutlet weak var brainDescriptionLabel: UILabel!
    @IBOutlet weak var brainBaseView: CircleView!

    class func build() -> ResultBrainView {
        return NSBundle.mainBundle().loadNibNamed("ResultBrain", owner: nil, options: nil)[0] as! ResultBrainView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addRecognizer()
        self.alpha = 0
        UIView.animateWithDuration(0.5,
            animations: {() -> Void in
                self.alpha = 1.0
            }, completion: nil
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.brainBaseView.makeCircle()
    }

    func onTap(recognizer: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }

    func setParam(user: User) {
        brainNameLabel.text = user.currentBrain().name
        brainDescriptionLabel.text = user.currentBrain().levelUpComment
        self.layoutIfNeeded()
        self.brainBaseView.makeCircle()

        let brainImageView = UIImageView(image: UIImage(named: "brain\(user.currentBrain().id)"))
        brainImageView.frame = brainBaseView.frame
        brainImageView.contentMode = UIViewContentMode.ScaleToFill
        self.brainBaseView.addSubviewOnCenter(brainImageView)
        self.layoutIfNeeded()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */

}

extension ResultBrainView {
    private func addRecognizer() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTap:"))
        self.addGestureRecognizer(recognizer)
    }
}
