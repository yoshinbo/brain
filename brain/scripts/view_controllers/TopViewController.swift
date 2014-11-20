//
//  TopViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class TopViewController: BaseViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
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
        self.navigationItem.title = "brain"

        self.user = User()
        self.levelLabel.text = NSString(format: "%d", user.level)
        self.expLabel.text = user.expAndRequiredExpWithFormat()
        self.energyLabel.text = user.energyAndMaxEnergyWithFormat()
        self.recoveryInfoLabel.text = NSString(format: "%d", user.energyRecoveryAt)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var expGaugeView:ExpGaugeView = ExpGaugeView.build()
        //expGaugeView.setParam(self.user.expRatePercentage())
        expGaugeView.setParamWithAnimation(40, afterExpRatePercentage: 50, levelUpNum: 2)
        self.expGaugeViewBase.addSubviewOnCenter(expGaugeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
