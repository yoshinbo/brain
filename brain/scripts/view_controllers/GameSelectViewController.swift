//
//  GameSelectViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class GameSelectViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var skillHolder1: UIView!
    @IBOutlet weak var skillHolder2: UIView!
    @IBOutlet weak var skillHolder3: UIView!
    @IBOutlet weak var skillHolder4: UIView!
    @IBOutlet weak var heartImageView: UIImageView!

    var gameModel: Games!
    var skillModel: Skills!
    var user: User!
    var skillButtonViews: [SkillButtonView] = []
    var wasteEnergy: Int = 0
    var isHandlingNotificationOnTapSkillButton: Bool = false

    class func build() -> GameSelectViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "GameSelect", bundle: nil)
        var viewController = storyboad.instantiateInitialViewController() as GameSelectViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.gameModel = Games()
        self.skillModel = Skills()
        self.user = User()

        //self.addBackButton()
        self.navigationItem.title = "Game Select"
        // For removing misterious space on table view header
        //self.automaticallyAdjustsScrollViewInsets = false

        self.updateEnergyLabel()
        self.setUpSkillHolder()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "handleNotificationOnTapSkillButton:",
            name: notificationOnTapSkillButton,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "handleNotificationUseEnergy:",
            name: notificationUseEnergy,
            object: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleNotificationOnTapSkillButton(notification: NSNotification) {
        if self.isHandlingNotificationOnTapSkillButton {
            return
        }
        self.isHandlingNotificationOnTapSkillButton = true
        if let userInfo = notification.userInfo as [String: Int]! {
            let skillId = userInfo["skillId"]!
            var targetSkillButtonView: SkillButtonView = self.skillButtonViews.filter({
                var skillButtonView: SkillButtonView = $0
                return skillButtonView.skill!.id == skillId
            })[0]
            if !targetSkillButtonView.isSelected {
                self.animationHeart()
            }
            self.wasteOrCancelEnergyProvisionaly(
                targetSkillButtonView.skill!.cost,
                isWaste: targetSkillButtonView.isSelected ? false : true
            )
            for skillButtonView: SkillButtonView in self.skillButtonViews {
                skillButtonView.checkOrToggle(skillId, currentEnergy: self.currentEnergy())
            }
        }
        self.updateEnergyLabel()
        self.updateHeart(self.currentEnergy() > 0)
        self.isHandlingNotificationOnTapSkillButton = false
    }

    func handleNotificationUseEnergy(notification: NSNotification) {
        self.user = User()
        self.updateEnergyLabel()
        for skillButtonView: SkillButtonView in self.skillButtonViews {
            skillButtonView.checkCapable(self.currentEnergy())
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameSelectViewController {
    private func aduptCell(cell:GameSelectContentCell, indexPath:NSIndexPath) {
        var game = self.gameModel.getByIndex(indexPath.row)
        cell.setParams(game, user: self.user)
    }

    // タッチした座興からNSIndexPathを返す
    private func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        var point = event.allTouches()?.anyObject()?.locationInView(self.tableView)
        return self.tableView.indexPathForRowAtPoint(point!)!
    }

    func onClickHelpButton(sender: UIButton, event: UIEvent) {
        var indexPath = self.indexPathForControlEvent(event)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as GameSelectContentCell
        if cell.game!.isSpeedMatch() {
            var (navigationController, viewController) = HelpViewController.build()
            viewController.gameTitle = cell.game!.title
            self.moveTo(navigationController)
        } else
        if cell.game!.isColorMatch() {
            println("color")
        }

    }
}

extension GameSelectViewController: UITableViewDelegate, UITableViewDataSource {
    // for UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedSkills = self.selectedSkills()

        // Skill選択リセット
        for skillButtonView: SkillButtonView in self.skillButtonViews {
            self.wasteEnergy = 0
            skillButtonView.clearSelect(self.currentEnergy())
        }
        // Energyの消費
        var costTotal = selectedSkills
            .map { $0.cost }
            .reduce(0, { $0 + $1 })

        if costTotal > 0 {
            self.user.useEnergy(costTotal)
        }

        // Game画面へ遷移
        var cell = tableView.cellForRowAtIndexPath(indexPath) as GameSelectContentCell
        if cell.game!.isSpeedMatch() {
            self.moveToInNavigationController(SpeedMatchViewController.build(selectedSkills))
        } else
        if cell.game!.isColorMatch() {
            println("color")
        }
    }

    // for UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameModel.totalGameNum()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as GameSelectContentCell
        self.aduptCell(cell, indexPath: indexPath)
        cell.helpButton.addTarget(self, action: "onClickHelpButton:event:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
}

extension GameSelectViewController {
    private func currentEnergy() -> Int {
        return self.user.currentEnergy() - self.wasteEnergy
    }

    private func updateEnergyLabel() {
        self.energyLabel.text = "\(self.currentEnergy())/\(self.user.maxEnergy)"
    }

    private func wasteOrCancelEnergyProvisionaly(cost: Int, isWaste: Bool) {
        if isWaste {
            self.wasteEnergy += cost
        }else {
            self.wasteEnergy -= cost
        }
    }

    private func setUpSkillHolder() {
        for skill in skillKinds {
            var skillButtonView: SkillButtonView = SkillButtonView.build()
            skillButtonView.setParams(self.skillModel.getById(skill.id)!, energy: self.currentEnergy())
            switch skill.id {
            case 1:
                skillHolder1.addSubViewToFix(skillButtonView)
            case 2:
                skillHolder2.addSubViewToFix(skillButtonView)
            case 3:
                skillHolder3.addSubViewToFix(skillButtonView)
            case 4:
                skillHolder4.addSubViewToFix(skillButtonView)
            default:
                break
            }
            self.skillButtonViews.append(skillButtonView)
        }
    }

    private func selectedSkills() -> [Skill] {
        return self.skillButtonViews
        .filter { $0.isSelected }
        .map { $0.skill! }
    }

    private func updateHeart(isActive: Bool) {
        if isActive {
            self.heartImageView.image = UIImage(named: "heart_fill")
        } else {
            self.heartImageView.image = UIImage(named: "heart_frame")
        }
    }

    private func animationHeart() {
        var heartImageView: UIImageView = UIImageView(frame: self.heartImageView.bounds)
        heartImageView.image = UIImage(named: "heart_fill")
        heartImageView.layer.position = ViewUtil.absFitPoint(self.heartImageView)
        self.view.addSubview(heartImageView)
        var originalX = heartImageView.layer.position.x
        var originalY = heartImageView.layer.position.y
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : 0.5,
            "delay"     : 0.0,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX + 10.0
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : 1.0,
            "delay"     : 0.5,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX - 10.0
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : 0.5,
            "delay"     : 1.5,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : 2.0,
            "delay"     : 0.0,
            "easing"    : GLDEasingNone,
            "centerY"   : originalY - 30
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"      : 0.5,
            "delay"         : 1.5,
            "easing"        : GLDEasingInSine,
            "alpha"         : 0.0,
            "completionBLock" : GLDTweenBlock({
                heartImageView.removeFromSuperview()
            })
        ])
    }
}
