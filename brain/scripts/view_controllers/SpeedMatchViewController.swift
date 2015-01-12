//
//  SpeedMatchViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class SpeedMatchViewController: GameBaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainView: UIView!        // GameのメインView
    @IBOutlet weak var informationBaseView: UIView!
    @IBOutlet weak var panelBaseView: UIView!
    @IBOutlet weak var helpLabel: UILabel!

    var informationView: InformationView!  // 情報を表示するView(コンボ数など)

    let panelTag = 100
    let gameId = 1
    var game: SpeedMatch!
    var interfaceView: InterfaceView!
    var skills: [Skill]!
    var isExpBonus: Bool!

    class func build(skills: [Skill], isExpBonus: Bool) -> SpeedMatchViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "SpeedMatch", bundle: nil)
        var viewController = storyboad.instantiateInitialViewController() as SpeedMatchViewController
        viewController.skills = skills
        viewController.isExpBonus = isExpBonus
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.game = SpeedMatch(
            game: Games().getById(gameId)!,
            skills: self.skills,
            isExpBonus: self.isExpBonus)
        self.game.delegate = self
        self.game.SpeedMatchDelegate = self
        self.panelBaseView.hidden = true
        self.helpLabel.text = NSLocalizedString("brain\(gameId)SubHelp1", comment: "")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.GALog(nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.informationView = InformationView.build()
        self.informationBaseView.addSubviewOnCenter(informationView)

        self.setInterfaceView()
        self.interfaceView.delegate = self
        self.interfaceView.hidden = true

        self.matchGameStart()
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

    @IBAction func onClickTrueButton(sender: AnyObject) {
        self.onClickAns("right")
    }

    @IBAction func onClickFalseButton(sender: AnyObject) {
        self.onClickAns("left")
    }
}

extension SpeedMatchViewController {
    private func matchGameStart() {
        self.game.start()
        self.renderPanel(self.game.currentPanelName())
    }

    private func onClickAns(direction: String) {
        if !self.interfaceView.hidden {
            self.judge(direction)
        }
    }

    private func setInterfaceView() {
        self.interfaceView = InterfaceView(frame: self.mainView.frame)
        self.mainView.addSubviewOnCenter(interfaceView)
    }
}

extension SpeedMatchViewController: GameBaseProtocol {
    func start() {
        self.judge("")
        var subHelp2 = NSLocalizedString("brain\(gameId)SubHelp2", comment: "")
        GLDTween.addTween(self.helpLabel, withParams: [
            "duration"      : 0.1,
            "delay"         : 0.0,
            "easing"        : GLDEasingInSine,
            "alpha"         : 0.0,
            "completionBLock" : GLDTweenBlock({
                self.helpLabel.text = subHelp2
            })
        ])
        GLDTween.addTween(self.helpLabel, withParams: [
            "duration"      : 0.4,
            "delay"         : 0.4,
            "easing"        : GLDEasingInSine,
            "alpha"         : 1.0
        ])
    }

    func renderTime(sec: Int) {
        self.timeLabel.text = NSString(format: "%d", sec)
        if !self.game.hasStarted {
            if 0 < sec && sec <= 3 {
                self.informationView.addReadySecImage(sec)
            }
        }
    }

    func renderScore(score: Int)
    {
        self.scoreLabel.text = NSString(format: "%d", score)
    }

    func renderResultView(result:[String:Int]) {
        self.interfaceView.hidden = true
        var resultViewController = ResultViewController.build()
        resultViewController.backGroundImage = self.view.convertToImage()
        resultViewController.setResult(result)
        resultViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(resultViewController, animated: true, completion: nil)
    }
}

extension SpeedMatchViewController: SpeedMatchProtocol {
    func renderPanel(name: String) {
        var panelView = PanelView.build()
        panelView.addImageViewByName(name)
        panelView.tag = self.panelTag
        panelView.frame = self.panelBaseView.frame
        panelView.layer.position = self.panelBaseView.layer.position
        self.mainView.addSubview(panelView)
        self.mainView.bringSubviewToFront(self.interfaceView)
    }
}

extension SpeedMatchViewController: InterfaceProtocal {
    func judge(direction: String) {

        // 判定とアニメーション中は入力禁止
        self.interfaceView.hidden = true

        var panelView = self.mainView.viewWithTag(self.panelTag) as PanelView
        if (direction == "right" || direction == "left") {
            let isCollect = self.game.isCollectAnswer(directionToAns[direction]!)
            isCollect
                ? self.game.collect()
                : self.game.incollect()
            self.renderAnswerEffect(
                self.informationView,
                isCollect: isCollect,
                bonusCoef: self.game.continuousCollectBonusCoef
            )
        }

        var animationAfterCondition: (() -> Void) = {
            [weak self] in
            panelView.removeFromSuperview()
            self!.game.addAndRenderPanel()
            self!.interfaceView.hidden = false
        }

        switch direction {
        case "right":
            panelView.animationRightPlay(self.mainView, condition: animationAfterCondition)
            break
        case "left":
            panelView.animationLeftPlay(self.mainView, condition: animationAfterCondition)
            break
        default:
            panelView.animationDownPlay(self.mainView, condition: animationAfterCondition)
            break
        }
    }
}
