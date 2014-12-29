//
//  HelpViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class HelpViewController: ModalBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var gameTitle: String = ""

    class func build() -> (UINavigationController, HelpViewController) {
        var storyboad: UIStoryboard = UIStoryboard(name: "Help", bundle: nil)
        var navigationController = storyboad.instantiateViewControllerWithIdentifier("HelpViewController") as UINavigationController
        return (navigationController, navigationController.topViewController as HelpViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Help"
        self.titleLabel.text = self.gameTitle
        self.setBlurBackground()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.GALog(nil)
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
