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

    var user: User!

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

        NSTimer.scheduledTimerWithTimeInterval(
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
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    }
}
