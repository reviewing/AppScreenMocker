//
//  UIUtils.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import QuartzCore

class UIUtils {
    static func UIColorFromARGB(argbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((argbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((argbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(argbValue & 0x0000FF) / 255.0,
            alpha: CGFloat((argbValue & 0xFF000000) >> 24) / 255.0
        )
    }
    
    static func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}