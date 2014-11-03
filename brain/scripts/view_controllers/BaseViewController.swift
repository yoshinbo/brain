//
//  ViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let navigationController = self.navigationController {
//            navigationController.navigationBar.setBackgroundImage(
//                UIImage(),
//                forBarMetrics: UIBarMetrics.Default
//            )
            navigationController.navigationBar.shadowImage = UIImage()
            //UINavigationBar.appearance().titleTextAttributes?[NSFontAttributeName] = UIFont(name: "HirakakuProN-W6", size:16)
            //navigationController.navigationBar.tintColor = UIColor.redColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ModalBaseViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            self.addCloseButton()
        }
    }
}