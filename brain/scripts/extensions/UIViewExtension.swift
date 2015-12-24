//
//  UIViewExtension.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

extension UIView {

    func setBlurBackground(parentView: UIView) {
        let image:UIImage = parentView.convertToImage()
        self.backgroundColor = UIColor(patternImage: ViewUtil.applyBlurWithRadius(image))
    }

    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func addSubviewOnCenter(view: UIView) {
        view.frame = ViewUtil.centerFrameInUIView(view, superView: self)
        self.addSubview(view)
    }

    func addImageviewOnCenterByName(name: String) -> UIImageView {
        let image: UIImage = UIImage(named: name)!
        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width*0.60,
            height: self.bounds.height*0.60
        ))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubviewOnCenter(imageView)
        return imageView
    }

    func addSubViewToFix(childView:UIView) {
        self.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        let layoutTop = NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0
        )
        let layoutBottom = NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        let layoutLeft = NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0
        )
        let layoutRight = NSLayoutConstraint(
            item: childView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0
        )
        let layoutConstraints: [NSLayoutConstraint] = [
            layoutTop, layoutBottom, layoutLeft, layoutRight
        ]
        self.addConstraints(layoutConstraints)
        self.layoutIfNeeded()
    }
}
