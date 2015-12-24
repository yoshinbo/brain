//
//  TopViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit
import GLDTween

class TopViewController: BaseViewController {

//    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var brainNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var brainImageCircleView: CircleView!
    @IBOutlet weak var energyImageView: UIImageView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var recoveryInfoLabel: UILabel!
    @IBOutlet weak var expGaugeViewBase: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var recoveryButtonBase: RoundedCornersBorderView!
    @IBOutlet weak var adToRecoverButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!

    var user: User!
    var timer: NSTimer!

    class func build() -> (UINavigationController, TopViewController) {
        let storyboad: UIStoryboard = UIStoryboard(name: "Top", bundle: nil)
        let navigationController = storyboad.instantiateViewControllerWithIdentifier("TopViewController") as! UINavigationController
        return (navigationController, navigationController.topViewController as! TopViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("gameTitle", comment: "")
        self.rankingButton.setTitle(NSLocalizedString("rankingButton", comment: ""), forState: UIControlState.Normal)
        self.bookButton.setTitle(NSLocalizedString("bookButton", comment: ""), forState: UIControlState.Normal)
        self.selectButton.setTitle(NSLocalizedString("selectButton", comment: ""), forState: UIControlState.Normal)
        self.adToRecoverButton.setTitle(NSLocalizedString("adToRecoverButton", comment: ""), forState: UIControlState.Normal)

        let imageHeight = self.adToRecoverButton.frame.height - 10
        let tmpMovieImage = UIImage(named: "movie")
        UIGraphicsBeginImageContext(CGSize(width: imageHeight, height: imageHeight))
        tmpMovieImage?.drawInRect(CGRect(x: 0, y: 0, width: imageHeight, height: imageHeight))
        let movieImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.adToRecoverButton.setImage(movieImage, forState: UIControlState.Normal)
        self.adToRecoverButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.adToRecoverButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);

        self.user = User()

        // 脳 >>>
        self.brainNameLabel.text = user.currentBrain().name
        self.levelLabel.text = NSString(
            format: NSLocalizedString("currentLevelFormat", comment: ""),
            user.level
        ) as String

        let brainImageView = UIImageView(image: UIImage(named: "brain\(user.currentBrain().id)"))
        brainImageView.frame = brainImageCircleView.frame
        brainImageView.contentMode = UIViewContentMode.ScaleToFill
        self.brainImageCircleView.addSubviewOnCenter(brainImageView)

        // 体力 >>>
        self.updateEnergyLabel()

        // 経験 >>>
        self.expLabel.text = NSString(
            format: NSLocalizedString("expToNextLevelFormat", comment: ""),
            user.remainRequiredExpForNextLevel()
        ) as String
        let expGaugeView:ExpGaugeView = ExpGaugeView.build()
        self.expGaugeViewBase.addSubViewToFix(expGaugeView)
        expGaugeView.setParam(self.user.expRatePercentage())

        // AD
        self.setAD()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateGameCenter()

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

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "handlenotificationLoadedAd:",
            name: notificationLoadedAd,
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

    func handlenotificationLoadedAd(notification: NSNotification) {
        self.setAD()
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
            adColonyZoneId,
            withDelegate: nil,
            withV4VCPrePopup: false,
            andV4VCPostPopup: false
        )
    }

    @IBAction func onClickRanking(sender: UIButton) {
        sound.playBySoundName("press")
        self.showLeaderboard()
    }

    @IBAction func onClickBook(sender: UIButton) {
        sound.playBySoundName("press")
        let (navigationController, _) = BookViewController.build()
        self.moveTo(navigationController)
    }
}

extension TopViewController {
    @IBAction func moveGameSelect(sender: UIButton) {
        sound.playBySoundName("press")
        let gameSelectViewController = GameSelectViewController.build()
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

    private func setAD() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.setAdForViewController(self)
            let isAdMobBannerVisible = appDelegate.isAdMobBannerVisible ? 1 : 0
            let isNendBannerVisible = appDelegate.isNendBannerVisible ? 1 : 0
            print("----> isAdMobBannerVisible:\(isAdMobBannerVisible), isNendBannerVisible:\(isNendBannerVisible)")
        }
    }
}

extension TopViewController: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    private func showLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        //gameCenterViewController.leaderboardIdentifier = "brain.spead_match.score"
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }

    private func updateGameCenter() {
        let localPlayer = GKLocalPlayer()
        localPlayer.authenticateHandler = {
            (viewController, error) -> Void in
            if ((viewController) != nil) { // ログイン確認処理：失敗-ログイン画面を表示
                self.presentViewController(viewController!, animated: true, completion: nil)
            }else{
                if (error == nil){
                    for game in gameKinds {
                        let bestScore: Int = (self.user.bestScores[game.id] != nil) ? self.user.bestScores[game.id]! : 0
                        if bestScore > 10 {
                            self.reportScores(bestScore, leaderboardid: game.leaderboardId)
                        }
                    }
                    if self.user.level > 3 {
                        self.reportScores(self.user.level, leaderboardid: levelLeaderboardId)
                    }
                }else{
                    // ログイン認証失敗 なにもしない
                }
            }
        }
    }

    private func reportScores(value:Int, leaderboardid:String){
        let score:GKScore = GKScore();
        score.value = Int64(value);
        score.leaderboardIdentifier = leaderboardid;
        let scoreArr:[GKScore] = [score];
        GKScore.reportScores(scoreArr, withCompletionHandler:{(error:NSError?) -> Void in
            if( (error != nil)){
                print("Sucess to reposrt \(leaderboardid)")
            }else{
                print("Faild to reposrt \(leaderboardid)")
            }
        });
    }
}
