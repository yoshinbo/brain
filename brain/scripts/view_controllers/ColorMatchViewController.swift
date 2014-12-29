//
//  ColorMatchViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/21.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class ColorMatchViewController: GameBaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var informationBaseView: UIView!
    @IBOutlet weak var panelBaseView: UIView!

    var informationView: InformationView!  // 情報を表示するView(コンボ数など)
    let panelTag = 100
    let gameId = 2
    var game: ColorMatch!
    var interfaceView: InterfaceView!
    var skills: [Skill]!

    class func build(skills: [Skill]) -> ColorMatchViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "ColorMatch", bundle: nil)
        var viewController = storyboad.instantiateInitialViewController() as ColorMatchViewController
        viewController.skills = skills
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.game = ColorMatch(game: Games().getById(gameId)!, skills: self.skills)
        self.game.delegate = self
        self.game.matchDelegate = self
        self.panelBaseView.hidden = true
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
    @IBAction func onClickTrueButton(sender: UIButton) {
        self.onClickAns("right")
    }

    @IBAction func onClickFalseButton(sender: UIButton) {
        self.onClickAns("left")
    }
}

extension ColorMatchViewController {
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

extension ColorMatchViewController: GameBaseProtocol {
    func start() {
        self.judge("")
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

extension ColorMatchViewController: ColorMatchProtocol {
    func renderPanel(name: String, color: String) {
        var panelView = PanelView.build()
        panelView.tag = self.panelTag
        panelView.frame = self.panelBaseView.frame
        panelView.layer.position = self.panelBaseView.layer.position
        switch color {
        case "Red":
            panelView.backgroundColor = redColor
        case "Blue":
            panelView.backgroundColor = blueColor
        case "Green":
            panelView.backgroundColor = greenColor
        case "Yellow":
            panelView.backgroundColor = yellowColor
        default:
            break
        }

        var panelLabel: UILabel = UILabel(frame: CGRectZero)
        panelLabel.text = name
        panelLabel.font = UIFont(name: "ArialMT", size: 25)
        panelLabel.sizeToFit()
        panelLabel.textColor = textColor
        panelView.addSubviewOnCenter(panelLabel)

        self.mainView.addSubview(panelView)
        self.mainView.bringSubviewToFront(self.interfaceView)
    }
}

extension ColorMatchViewController: InterfaceProtocal {
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
