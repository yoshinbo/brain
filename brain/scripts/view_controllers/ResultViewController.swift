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

        self.scoreLabel.text = NSString(format: "%d", self.result["score"]!)
        let bestScoreLabelFormat: String = self.result["isBestScore"]! == 0 ?
            NSLocalizedString("bestScoreFormat", comment: "") :
            NSLocalizedString("newBestScoreFormat", comment: "")
        self.bestScoreLabel.text = NSString(
            format: bestScoreLabelFormat,
            self.result["bestScore"]!
        )
        self.levelLabel.text = NSString(
            format: NSLocalizedString("currentLevelFormat", comment: ""),
            self.result["afterLevel"]!
        )
        self.expLabel.text = NSString(
            format: NSLocalizedString("expToNextLevelFormat", comment: ""),
            self.result["afterExp"]!
        )
    }

    override func viewDidAppear(animated: Bool) {
        var expGaugeView: ExpGaugeView = ExpGaugeView.build()
        self.expGaugeViewBase.addSubViewToFix(expGaugeView)
        expGaugeView.setParamWithAnimation(
            self.result["beforeExpRatePercentage"]!,
            afterExpRatePercentage: self.result["afterExpRatePercent"]!,
            levelUpNum: self.result["levelUpNum"]!
        )
    }

    override func viewDidLayoutSubviews() {
        // 再度、真円になるようにリレンダリング
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
        var title = NSString(
            format: NSLocalizedString("shareTitleFormat", comment: ""),
            self.result["score"]!
        )
        self.showShareActionSheet(title)
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
