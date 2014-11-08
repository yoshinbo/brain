//
//  UserInterfaceView.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

protocol InterfaceProtocal {
    func judge(direction: String)
}

class InterfaceView: UIView {

    var delegate: InterfaceProtocal!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setGesture()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setGesture()
    }

    private func setGesture() {
        // Swipe Gesture
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)

        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                self.delegate.judge("right")
            case UISwipeGestureRecognizerDirection.Left:
                self.delegate.judge("left")
            default:
                break
            }
        }
    }
}
