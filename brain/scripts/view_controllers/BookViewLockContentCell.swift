//
//  BookViewLockContentCell.swift
//  brain
//
//  Created by Yoshikazu Oda on 2015/01/08.
//  Copyright (c) 2015年 yoshinbo. All rights reserved.
//

import UIKit

class BookViewLockContentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brainImageView: UIImageView!
    @IBOutlet weak var brainImageBaseView: CircleView!
    @IBOutlet weak var condition1ImageView: UIImageView!
    @IBOutlet weak var condition2ImageView: UIImageView!
    @IBOutlet weak var condition3ImageView: UIImageView!
    @IBOutlet weak var condition1Label: UILabel!
    @IBOutlet weak var condition2Label: UILabel!
    @IBOutlet weak var condition3Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.brainImageBaseView.makeCircle()
    }

    func setParams(brainId : Int) {
        let brain = User.getBrainById(brainId)
        let user = User()
        let games = Games()

        var currentBrain = user.currentBrain()
        var previousBrainId = brainId - 1

        nameLabel.text = brain.unnamed

        // condition1
        self.condition1ImageView.image = conditionImageByBool(currentBrain.id >= previousBrainId)
        self.condition1Label.text = NSString(
            format: NSLocalizedString("brainOpenCondition1", comment: ""),
            User.getBrainById(previousBrainId).unnamed
        )

        // condition2
        self.condition2ImageView.image = conditionImageByBool(user.level >= brain.requiredLevel)
        self.condition2Label.text = NSString(
            format: NSLocalizedString("brainOpenCondition2", comment: ""),
            brain.requiredLevel
        )

        // condition3
        let requiredGameId = brain.requiredGameId
        let bestScore: Int = (user.bestScores[requiredGameId] != nil) ? user.bestScores[requiredGameId]! : 0
        self.condition3ImageView.image = conditionImageByBool(bestScore >= brain.requiredScore)
        self.condition3Label.text = NSString(
            format: NSLocalizedString("brainOpenCondition3", comment: ""),
            games.getById(requiredGameId)!.title,
            brain.requiredScore
        )
        self.layoutIfNeeded()
    }

}

extension BookViewLockContentCell {
    private func conditionImageByBool(isOk: Bool) -> UIImage {
        return UIImage(named: isOk ? "ok_frame" : "ok_deactive")!
    }
}
