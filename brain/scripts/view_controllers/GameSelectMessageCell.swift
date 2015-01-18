//
//  GameSelectMessageCell.swift
//  brain
//
//  Created by Yoshikazu Oda on 2015/01/19.
//  Copyright (c) 2015年 yoshinbo. All rights reserved.
//

import UIKit

class GameSelectMessageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GameSelectMessageCell {
    func setParams() {
        self.titleLabel.text =  NSLocalizedString("messageCellTitle", comment: "")
        self.subTitleLabel.text = NSLocalizedString("messageCellSubTitle", comment: "")
    }
}
