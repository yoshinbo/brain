//
//  ResultViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/09.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var backGroundImage: UIImage?
    
    class func build() -> ResultViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "Result", bundle: nil)
        return storyboad.instantiateInitialViewController() as ResultViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: ViewUtil.applyBlurWithRadius(self.backGroundImage!))
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
