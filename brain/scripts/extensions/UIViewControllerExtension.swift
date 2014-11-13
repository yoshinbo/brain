//
//  UIViewControllerExtension.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func moveTo(viewController: UIViewController) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func moveToInNavigationController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func backPrevViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func closeViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addBackButton() {
        if let navigationController = self.navigationController {
            var buttonItem = UIBarButtonItem(
                image: UIImage(named: ""),
                style: .Plain,
                target: self,
                action: Selector("backPrevViewController")
            )
            self.navigationItem.leftBarButtonItem = buttonItem
            self.navigationController?.interactivePopGestureRecognizer.delegate = self
        }
    }
    
    func addCloseButton() {
        if let navigationController = self.navigationController {
            var buttonItem = UIBarButtonItem(
                image: UIImage(named: ""),
                style: .Plain,
                target: self,
                action: Selector("closeViewController")
            )
            buttonItem.title = "Close"
            self.navigationItem.leftBarButtonItem = buttonItem
            self.navigationController?.interactivePopGestureRecognizer.delegate = self
        }
    }
    
    func setBlurBackground() {
        if let parentViewController = self.presentingViewController? {
            var image:UIImage = parentViewController.view.convertToImage()
            self.view.backgroundColor = UIColor(patternImage: ViewUtil.applyBlurWithRadius(image))
        }
    }
}

extension UIViewController:UIGestureRecognizerDelegate {
}