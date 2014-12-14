//
//  BookViewContentCell.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/14.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class BookViewContentCell: UITableViewCell {

    @IBOutlet weak var brainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var requiredConditionLabel: UILabel!
    @IBOutlet weak var brainBaseView: CircleView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setParams(brainId : Int) {
        var brain = User.getBrainById(brainId)
        self.nameLabel.text = brain.name
        self.descriptionLabel.text = brain.desc
        self.requiredConditionLabel.text = "\(brain.requiredLevel)"
    }

    func viewDidLayoutSubviews() {
        self.brainBaseView.makeCircle()
    }
}
