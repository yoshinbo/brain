//
//  SpeedMatchViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class SpeedMatchViewController: BaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainView: UIView!        // GameのメインView
    @IBOutlet weak var infomationView: UIView!  // 情報を表示するView(コンボ数など)

    let imageTag = 100
    let gameId = 1
    var game: SpeedMatch!
    var interfaceView: InterfaceView!

    class func build() -> SpeedMatchViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "SpeedMatch", bundle: nil)
        var viewController = storyboad.instantiateInitialViewController() as SpeedMatchViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.game = SpeedMatch(game: Games().getById(gameId))
        self.game.delegate = self
        self.game.SpeedMatchDelegate = self

        self.setInterfaceView()
        self.interfaceView.delegate = self
        self.interfaceView.hidden = true

        self.game.start()
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

extension SpeedMatchViewController {
    func setInterfaceView() {
        self.interfaceView = InterfaceView(frame: self.mainView.frame)
        self.interfaceView.center = self.mainView.center
        self.view.addSubview(interfaceView)
    }

}

extension SpeedMatchViewController: GameBaseProtocol {
    func start() {
        println("start")
    }

    func renderTime(sec: Int) {
        self.timeLabel.text = NSString(format: "%d", sec)
    }

    func renderScore(score: Int)
    {
        self.scoreLabel.text = NSString(format: "%d", score)
    }

    func renderResultView() {
        println("game over")
    }
}

extension SpeedMatchViewController: SpeedMatchProtocol {
    func renderPanel(name: String) {
        println("panel")
    }
}

extension SpeedMatchViewController: InterfaceProtocal {
    func judge(direction: String) {
        println("OK")
    }
}
