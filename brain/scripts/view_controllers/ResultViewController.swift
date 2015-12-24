//
//  ResultViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/09.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit
import GLDTween

class ResultViewController: BaseViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expGaugeViewBase: UIView!
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var topMenuButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    var backGroundImage: UIImage?
    var result: [String: Int]!

    class func build() -> ResultViewController {
        let storyboad: UIStoryboard = UIStoryboard(name: "Result", bundle: nil)
        return storyboad.instantiateInitialViewController() as! ResultViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: ViewUtil.applyBlurWithRadius(self.backGroundImage!))
        self.shareButton.setTitle(NSLocalizedString("shareButton", comment: ""), forState: UIControlState.Normal)
        self.topMenuButton.setTitle(NSLocalizedString("topMenuButton", comment: ""), forState: UIControlState.Normal)
        self.selectButton.setTitle(NSLocalizedString("selectButton", comment: ""), forState: UIControlState.Normal)

        self.scoreLabel.text = NSString(format: "%d", self.result["score"]!) as String
        let bestScoreLabelFormat: String = self.result["isBestScore"]! == 0 ?
            NSLocalizedString("bestScoreFormat", comment: "") :
            NSLocalizedString("newBestScoreFormat", comment: "")
        self.bestScoreLabel.text = NSString(
            format: bestScoreLabelFormat,
            self.result["bestScore"]!
        ) as String
        self.levelLabel.text = NSString(
            format: NSLocalizedString("currentLevelFormat", comment: ""),
            self.result["beforeLevel"]!
        ) as String
        self.expLabel.text = NSString(
            format: NSLocalizedString("expToNextLevelFormat", comment: ""),
            self.result["remainRequiredExpForNextLevel"]!
        ) as String

        // AD
        self.setAD()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let gameId = self.result["gameId"]!
        self.GALog("brain.ResultViewController.\(gameId)")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startExpGaugeAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 再度、真円になるようにリレンダリング
        self.circleView.makeCircle()
    }

    func setGameResult(result:[String:Int]) {
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
        sound.playBySoundName("press")
        let title = NSString(
            format: NSLocalizedString("shareTitleFormat", comment: ""),
            self.result["score"]!
        )
        self.showShareActionSheet(title as String)
    }

    @IBAction func onClickGameSelect(sender: UIButton) {
        sound.playBySoundName("press")
        let (navigationController, _) = TopViewController.build()
        self.presentViewController(navigationController, animated: true, completion: {
            let gameSelectViewController = GameSelectViewController.build()
            navigationController.pushViewController(gameSelectViewController, animated: true)
        })
    }

    @IBAction func onClickTopMenu(sender: UIButton) {
        sound.playBySoundName("press")
        let (navigationController, _) = TopViewController.build()
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension ResultViewController: ExpGaugeProtocol {
    func levelUp() {
        sound.playBySoundName("levelup")
        self.levelLabel.text = NSString(
            format: NSLocalizedString("currentLevelFormat", comment: ""),
            self.result["afterLevel"]!
        ) as String
        let originalHeight: CGFloat = self.levelLabel.frame.origin.y
        GLDTween.addTween(self.levelLabel, withParams: [
            "duration"  : 1.0,
            "delay"     : 0.0,
            "easing"    : GLDEasingNone,
            "y"         : originalHeight - 20,
        ])
        GLDTween.addTween(self.levelLabel, withParams: [
            "duration"  : 0.5,
            "delay"     : 0.5,
            "easing"    : GLDEasingOutBounce,
            "y"   : originalHeight,
        ])
    }
}

extension ResultViewController {
    private func startExpGaugeAnimation() {
        // Brainがレベルアップした時はポップアップを見せたいのでその他のボタンの入力禁止
        if self.hasBrainUpdated() {
            self.view.userInteractionEnabled = false
        }
        let expGaugeView: ExpGaugeView = ExpGaugeView.build()
        expGaugeView.delegate = self
        self.expGaugeViewBase.addSubViewToFix(expGaugeView)
        expGaugeView.setParamWithAnimation(
            self.result["beforeExpRatePercentage"]!,
            afterExpRatePercentage: self.result["afterExpRatePercent"]!,
            levelUpNum: self.result["levelUpNum"]!,
            condition: self.conditionAfterExpGaugeAnimation
        )
    }

    private func conditionAfterExpGaugeAnimation() {
        if self.hasBrainUpdated() {
            sound.playBySoundName("newbrain")
            let resultBrainView: ResultBrainView = ResultBrainView.build()
            self.view.addSubViewToFix(resultBrainView)
            resultBrainView.setParam(User())
            resultBrainView.setBlurBackground(self.view)
            self.view.userInteractionEnabled = true
        }
    }

    private func hasBrainUpdated() -> Bool {
        return self.result["newBrainId"] != 0
    }

    private func setAD() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.setAdForViewController(self)
        }
    }
}

