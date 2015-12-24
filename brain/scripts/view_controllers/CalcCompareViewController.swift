//
//  CalcCompareViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/31.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit
import GLDTween

class CalcCompareViewController: GameBaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var informationBaseView: UIView!
    @IBOutlet weak var panelBaseView: UIView!
    @IBOutlet weak var helpLabel: UILabel!

    var informationView: InformationView!  // 情報を表示するView(コンボ数など)
    let panelTag = 100
    let gameId = 3
    var game: CalcCompare!
    var interfaceView: InterfaceView!
    var skills: [Skill]!
    var isExpBonus: Bool!
    var hasPlayStartSound: Bool = false

    class func build(skills: [Skill], isExpBonus: Bool) -> CalcCompareViewController {
        let storyboad: UIStoryboard = UIStoryboard(name: "CalcCompare", bundle: nil)
        let viewController = storyboad.instantiateInitialViewController() as! CalcCompareViewController
        viewController.skills = skills
        viewController.isExpBonus = isExpBonus
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.game = CalcCompare(
            game: Games().getById(gameId)!,
            skills: self.skills,
            isExpBonus: self.isExpBonus
        )
        self.game.delegate = self
        self.game.matchDelegate = self
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
        self.informationView.delegate = self

        self.setInterfaceView()
        self.interfaceView.delegate = self
        self.interfaceView.hidden = true

        self.matchGameStart()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.game.stopTimer()
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
    @IBAction func onClickTrueButton(sender: UIButton) {
        self.onClickAns("right")
    }

    @IBAction func onClickFalseButton(sender: UIButton) {
        self.onClickAns("left")
    }
}

extension CalcCompareViewController {
    private func matchGameStart() {
        self.game.start()
        self.game.addAndRenderPanel()
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

extension CalcCompareViewController: GameBaseProtocol {
    func start() {
        self.judge("")
        let subHelp2 = NSLocalizedString("brain\(gameId)SubHelp2", comment: "")
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
        self.timeLabel.text = NSString(format: "%d", sec) as String
        if !self.game.hasStarted {
            if 0 < sec && sec <= 3 {
                sound.playBySoundName("countdown")
                self.informationView.addReadySecImage(sec)
            }
        } else if !hasPlayStartSound {
            hasPlayStartSound = true
            sound.playBySoundName("start")
        }
    }

    func renderScore(score: Int)
    {
        self.scoreLabel.text = NSString(format: "%d", score) as String
    }

    func renderResultView(result:[String:Int]) {
        self.interfaceView.hidden = true
        let resultViewController = ResultViewController.build()
        resultViewController.backGroundImage = self.view.convertToImage()
        resultViewController.setGameResult(result)
        resultViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(resultViewController, animated: true, completion: nil)
    }
}

extension CalcCompareViewController: CalcCompareProtocol {
    func renderPanel(formula: String) {
        let panelView = PanelView.build()
        panelView.tag = self.panelTag
        panelView.frame = self.panelBaseView.frame
        panelView.layer.position = self.panelBaseView.layer.position

        let panelLabel: UILabel = UILabel(frame: CGRectZero)
        panelLabel.text = formula
        panelLabel.font = UIFont.boldSystemFontOfSize(40)
        panelLabel.sizeToFit()
        panelLabel.textColor = orangeColor
        panelView.addSubviewOnCenter(panelLabel)

        self.mainView.addSubview(panelView)
        self.mainView.bringSubviewToFront(self.interfaceView)
    }
}

extension CalcCompareViewController: InterfaceProtocal {
    func judge(direction: String) {

        // 判定とアニメーション中は入力禁止
        self.interfaceView.hidden = true

        let panelView = self.mainView.viewWithTag(self.panelTag) as! PanelView
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

        let animationAfterCondition: (() -> Void) = {
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

extension CalcCompareViewController: InformationProtocol {
    func setBackgroundAlpha(degree: Int) {
        let alphaCoef:CGFloat = maxBackgroundColorAlpha / CGFloat(maxContinuousCollectAnsBonus)
        let alpha = alphaCoef * CGFloat(degree)
        self.mainView.backgroundColor = orangeColor.colorWithAlphaComponent(alpha)
    }
}
