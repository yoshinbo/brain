//
//  ViewUtil.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class ViewUtil {
    class func centerFrameInUIView(view: UIView, superView: UIView) -> CGRect {
        var width: CGFloat = view.frame.size.width
        var height: CGFloat = view.frame.size.height
        var marginX: CGFloat = superView.frame.size.width - width
        var marginY: CGFloat = superView.frame.size.height - height
        return CGRectMake(marginX/2.0, marginY/2.0, width, height)
    }
}