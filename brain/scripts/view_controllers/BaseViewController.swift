//
//  ViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var sound = Sound.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let navigationController = self.navigationController {
            navigationController.navigationBar.shadowImage = UIImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showShareActionSheet(title: String) {
        let actionSheet = UIActivityViewController(activityItems: [title, storeURL], applicationActivities: nil)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        // for ios
        if actionSheet.respondsToSelector("popoverPresentationController") {
            if #available(iOS 8.0, *) {
                let presentationController = actionSheet.popoverPresentationController
                presentationController?.sourceView = self.view
            } else {
                // Fallback on earlier versions
            }
        }
    }

    func GALog(name: String?) {
        // TODO: - 対応
        //if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        //    let screenName = (name != nil) ? name : reflect(self).summary
        //    let build = GAIDictionaryBuilder.createAppView().set(
        //        screenName,
        //        forKey: kGAIScreenName
        //    ).build()
        //    appDelegate.tracker?.send(build)
        //}
    }
}

class ModalBaseViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = self.navigationController {
            self.addCloseButton()
        }
    }
}

class GameBaseViewController: BaseViewController {
    func renderAnswerEffect(informationView: InformationView, isCollect: Bool, bonusCoef: Int) {
        if isCollect {
            sound.playBySoundName("ok")
            informationView.addOKImageWithBonusRate(bonusCoef)
        } else {
            sound.playBySoundName("ng")
            informationView.addNGImage()
        }
    }
}
