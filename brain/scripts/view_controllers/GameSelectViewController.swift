//
//  GameSelectViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit
import GLDTween

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
    var animatingImageViews: [UIImageView] = []
    var wasteEnergy: Int = 0
    var isHandlingNotificationOnTapSkillButton: Bool = false

    class func build() -> GameSelectViewController {
        let storyboad: UIStoryboard = UIStoryboard(name: "GameSelect", bundle: nil)
        let viewController = storyboad.instantiateInitialViewController() as! GameSelectViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("selectButton", comment: "")

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.gameModel = Games()
        self.skillModel = Skills()
        self.user = User()

        self.updateEnergyLabel()
        self.setUpSkillHolder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

        self.GALog(nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        GLDTween .removeAllTweens()
        for imageView: UIImageView in animatingImageViews {
            imageView.removeFromSuperview()
        }
        NSNotificationCenter.defaultCenter().removeObserver(self);
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
        if let userInfo = notification.userInfo as! [String: Int]! {
            let skillId = userInfo["skillId"]!
            let targetSkillButtonView: SkillButtonView = self.skillButtonViews.filter({
                let skillButtonView: SkillButtonView = $0
                return skillButtonView.skill!.id == skillId
            })[0]
            if !targetSkillButtonView.isSelected {
                sound.playBySoundName("skill")
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

    @IBAction func onClickSkillHelp(sender: UIButton) {
        sound.playBySoundName("press")
        let (navigationController, viewController) = HelpViewController.build()
        viewController.gameTitle = NSLocalizedString("skillHelpTitle", comment: "")
        viewController.gameHelp = NSLocalizedString("skillHelpDescription", comment: "")
        self.moveTo(navigationController)
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
        let game = self.gameModel.getByIndex(indexPath.row)
        cell.setParams(game, user: self.user)
    }

    // タッチした座興からNSIndexPathを返す
    private func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)
        return indexPath!
    }

    func onClickHelpButton(sender: UIButton, event: UIEvent) {
        sound.playBySoundName("press")
        let indexPath = self.indexPathForControlEvent(event)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GameSelectContentCell
        let (navigationController, viewController) = HelpViewController.build()
        viewController.gameTitle = cell.game!.title
        viewController.gameHelp = cell.game!.helpDesc
        self.moveTo(navigationController)
    }
}

extension GameSelectViewController: UITableViewDelegate, UITableViewDataSource {
    // for UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.gameModel.totalGameNum() == indexPath.row {
            sound.playBySoundName("press")
            UIApplication.sharedApplication().openURL(NSURL(string: storeURL)!)
        } else {
            let selectedSkills = self.selectedSkills()

            // Skill選択リセット
            for skillButtonView: SkillButtonView in self.skillButtonViews {
                self.wasteEnergy = 0
                skillButtonView.clearSelect(self.currentEnergy())
            }
            // Energyの消費
            let costTotal = selectedSkills
                .map { $0.cost }
                .reduce(0, combine: { $0 + $1 })

            if costTotal > 0 {
                self.user.useEnergy(costTotal)
            }

            // Game画面へ遷移
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! GameSelectContentCell
            if cell.game!.isSpeedMatch() {
                self.moveToInNavigationController(SpeedMatchViewController.build(selectedSkills, isExpBonus: cell.isExpBonus))
            } else
            if cell.game!.isColorMatch() {
                self.moveToInNavigationController(ColorMatchViewController.build(selectedSkills, isExpBonus: cell.isExpBonus))
            } else
            if cell.game!.isCalcCompare() {
                self.moveToInNavigationController(CalcCompareViewController.build(selectedSkills, isExpBonus: cell.isExpBonus))
            }
        }
    }

    // for UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameModel.totalGameNum() + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.gameModel.totalGameNum() == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! GameSelectMessageCell
            cell.setParams()
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! GameSelectContentCell
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
            let skillButtonView: SkillButtonView = SkillButtonView.build()
            skillButtonView.setParams(user, skill: self.skillModel.getById(skill.id)!, energy: self.currentEnergy())
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
        let heartImageView: UIImageView = UIImageView(frame: self.heartImageView.bounds)
        heartImageView.image = UIImage(named: "heart_fill")
        heartImageView.layer.position = ViewUtil.absFitPoint(self.heartImageView)
        self.view.addSubview(heartImageView)
        let originalX = heartImageView.layer.position.x
        let originalY = heartImageView.layer.position.y
        self.animatingImageViews.append(heartImageView)

        let animationBaseDuration = 0.2
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : animationBaseDuration,
            "delay"     : 0.0,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX + 10.0
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : animationBaseDuration*2,
            "delay"     : animationBaseDuration,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX - 10.0
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : animationBaseDuration,
            "delay"     : animationBaseDuration*3,
            "easing"    : GLDEasingNone,
            "centerX"   : originalX
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"  : animationBaseDuration*4,
            "delay"     : 0.0,
            "easing"    : GLDEasingNone,
            "centerY"   : originalY - 30
        ])
        GLDTween.addTween(heartImageView, withParams: [
            "duration"      : animationBaseDuration*3,
            "delay"         : animationBaseDuration,
            "easing"        : GLDEasingInSine,
            "alpha"         : 0.0
        ])
    }
}
