//
//  ResultViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/09.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class ResultViewController: BaseViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expGaugeViewBase: UIView!
    @IBOutlet weak var circleView: CircleView!
    var backGroundImage: UIImage?
    var result: [String: Int]!

    class func build() -> ResultViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "Result", bundle: nil)
        return storyboad.instantiateInitialViewController() as ResultViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: ViewUtil.applyBlurWithRadius(self.backGroundImage!))

        var afterExp: Int = self.result["afterExp"]!
        var afterLevel: Int = self.result["afterLevel"]!

        self.scoreLabel.text = NSString(format: "%d", self.result["score"]!)
        self.levelLabel.text = NSString(format: "Level : %d",afterLevel)
        self.expLabel.text = NSString(format: "Exp : %d", afterExp)
    }

    override func viewDidAppear(animated: Bool) {
        var expGaugeView:ExpGaugeView = ExpGaugeView.build()
        expGaugeView.setParamWithAnimation(
            self.result["beforeExpRatePercentage"]!,
            afterExpRatePercentage: self.result["afterExpRatePercent"]!,
            levelUpNum: self.result["levelUpNum"]!
        )
        self.expGaugeViewBase.addSubviewOnCenter(expGaugeView)
    }

    override func viewDidLayoutSubviews() {
        self.circleView.makeCircle()
    }

    func setResult(result:[String:Int]) {
        self.result = result
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
    @IBAction func onClickShare(sender: AnyObject) {
        self.showShareActionSheet("")
    }

    @IBAction func onClickGameSelect(sender: UIButton) {
        var (navigationController, topViewController) = TopViewController.build()
        self.presentViewController(navigationController, animated: true, completion: {
            var gameSelectViewController = GameSelectViewController.build()
            navigationController.pushViewController(gameSelectViewController, animated: true)
        })
    }

    @IBAction func onClickTopMenu(sender: UIButton) {
        var (navigationController, topViewController) = TopViewController.build()
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}
