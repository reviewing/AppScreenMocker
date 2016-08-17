//
//  UIView+Gestures.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/16/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

extension UIView {
    func addSingleTapGesture(target: AnyObject?, action: Selector) {
        let singleTap = UITapGestureRecognizer(target: target, action:action)
        singleTap.numberOfTapsRequired = 1
        self.userInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
}