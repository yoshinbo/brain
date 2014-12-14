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

    class func applyBlurWithRadius(image: UIImage) -> UIImage {
        return image.applyBlurWithRadius(
            10,
            tintColor: UIColor(white: 0.11, alpha: 0.73),
            saturationDeltaFactor:1.3,
            maskImage: nil
        )
    }

    class func absFitPoint(view: UIView) -> CGPoint {
        var ret: CGPoint = absPoint(view)
        ret.x += view.frame.width/2
        ret.y += view.frame.height/2
        return ret
    }

    class func absPoint(view: UIView) -> CGPoint {
        var ret: CGPoint = CGPointMake(view.frame.origin.x, view.frame.origin.y)
        if view.superview != nil {
            var addPoint = absPoint(view.superview!)
            ret = CGPointMake(ret.x + addPoint.x, ret.y + addPoint.y)
        }
        return ret
    }
}
