//
//  UIViewExtension.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/01.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

extension UIView {

    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func addSubviewOnCenter(view: UIView) {
        view.frame = ViewUtil.centerFrameInUIView(view, superView: self)
        self.addSubview(view)
    }

    func addImageviewOnCenterByName(name: String) {
        var label = UILabel(frame: self.frame)
        label.text = name
        self.addSubviewOnCenter(label)
    }
}
