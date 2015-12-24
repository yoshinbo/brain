//
//  GameSelectContentCell.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class GameSelectContentCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var expBonusImage: UIImageView!

    var game: Game?
    var isExpBonus: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension GameSelectContentCell {
    func setParams(game: Game, user: User) {
        self.game = game
        self.titleLabel.text = game.title
        let bestScore: Int = (user.bestScores[game.id] != nil) ? user.bestScores[game.id]! : 0
        self.infoLabel.text = NSString(
            format: NSLocalizedString("bestScoreFormat", comment: ""),
            bestScore
        ) as String
        if game.isExpBonus() {
            self.expBonusImage.hidden = false
        } else {
            self.expBonusImage.hidden = true
        }
        self.isExpBonus = !self.expBonusImage.hidden
    }
}
