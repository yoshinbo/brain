//
//  UIViewControllerExtension.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func backPrevViewController() {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    func setBlurBackground() {
        if let parentViewController = self.presentingViewController? {
            var image:UIImage = parentViewController.view.convertToImage()
            image = image.applyBlurWithRadius(
                10,
                tintColor: UIColor(white: 1.0, alpha: 0.2),
                saturationDeltaFactor:1.3,
                maskImage: nil
            )
            self.view.backgroundColor = UIColor(patternImage: image)
            
        }
    }
}

extension UIViewController:UIGestureRecognizerDelegate {
}