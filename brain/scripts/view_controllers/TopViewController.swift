//
//  TopViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class TopViewController: BaseViewController {

//    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var brainNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var brainImageView: UIImageView!
    @IBOutlet weak var brainImageCircleView: CircleView!
    @IBOutlet weak var energyImageView: UIImageView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var recoveryInfoLabel: UILabel!
    @IBOutlet weak var expGaugeViewBase: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var recoveryButtonBase: RoundedCornersBorderView!

    var user: User!
    var timer: NSTimer!

    class func build() -> (UINavigationController, TopViewController) {
        var storyboad: UIStoryboard = UIStoryboard(name: "Top", bundle: nil)
        var navigationController = storyboad.instantiateViewControllerWithIdentifier("TopViewController") as UINavigationController
        return (navigationController, navigationController.topViewController as TopViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("gameTitle", comment: "")

        self.user = User()

        // 脳 >>>
        self.brainNameLabel.text = user.currentBrain().name
        self.levelLabel.text = NSString(
            format: NSLocalizedString("currentLevelFormat", comment: ""),
            user.level
        )

        // 体力 >>>
        self.updateEnergyLabel()

        // 経験 >>>
        self.expLabel.text = NSString(
            format: NSLocalizedString("expToNextLevelFormat", comment: ""),
            user.remainRequiredExpForNextLevel()
        )
        var expGaugeView:ExpGaugeView = ExpGaugeView.build()
        self.expGaugeViewBase.addSubViewToFix(expGaugeView)
        expGaugeView.setParam(self.user.expRatePercentage())

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.user = User()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target: self,
            selector: Selector("updateEnergyLabelByTimer"),
            userInfo: nil,
            repeats: true
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
        self.timer.invalidate()
        self.timer = nil
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    override func viewDidLayoutSubviews() {
        // 再度、真円になるようにリレンダリング
        self.brainImageCircleView.makeCircle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateEnergyLabelByTimer() {
        self.updateEnergyLabel()
    }

    func handleNotificationUseEnergy(notification: NSNotification) {
        self.user = User()
        self.updateEnergyLabel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickRecovery(sender: UIButton) {
        AdColony.playVideoAdForZone(
            "vz466b9493eb11438fa2",
            withDelegate: nil,
            withV4VCPrePopup: false,
            andV4VCPostPopup: false
        )
    }

    @IBAction func onClickRanking(sender: UIButton) {
        println("ranking...")
    }

    @IBAction func onClickBook(sender: UIButton) {
        var (navigationController, viewController) = BookViewController.build()
        self.moveTo(navigationController)
    }
}

extension TopViewController {
    @IBAction func moveGameSelect(sender: UIButton) {
        var gameSelectViewController = GameSelectViewController.build()
        self.navigationController?.pushViewController(gameSelectViewController, animated: true)
    }
}

extension TopViewController {
    private func updateEnergyLabel() {
        self.energyLabel.text = "\(self.user.currentEnergy())/\(self.user.maxEnergy)"
        self.recoveryInfoLabel.text = DateUtil.getUntilTime(self.user.energyRecoveryAt)
        if self.user.isFullEnergy() && self.recoveryButtonBase.userInteractionEnabled {
            self.recoveryButtonBase.userInteractionEnabled = false
            GLDTween.addTween(self.recoveryButtonBase, withParams: [
                "duration"      : 0.2,
                "delay"         : 0.0,
                "easing"        : GLDEasingInSine,
                "alpha"         : 0.0
            ])
        } else if !self.user.isFullEnergy() && !self.recoveryButtonBase.userInteractionEnabled {
            self.recoveryButtonBase.userInteractionEnabled = true
            GLDTween.addTween(self.recoveryButtonBase, withParams: [
                "duration"      : 0.2,
                "delay"         : 0.0,
                "easing"        : GLDEasingInSine,
                "alpha"         : 1.0
            ])
        }
    }
}
