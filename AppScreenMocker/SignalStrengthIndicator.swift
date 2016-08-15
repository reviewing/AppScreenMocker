//
//  SignalStrengthIndicator.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class SignalStrengthIndicator: UIView {
    
    override func drawRect(rect: CGRect) {
        let radius = (rect.width - 6) / 5;
        
        for i in 0..<5 {
            if i < strength {
                let iRect: CGRect = CGRectMake(rect.origin.x + (CGFloat(i) * radius + CGFloat(i) * 1.5), rect.origin.y, radius, radius)
                let path = UIBezierPath(ovalInRect: iRect)
                UIColor.whiteColor().setFill()
                path.fill()
            } else {
                let iRect: CGRect = CGRectMake(rect.origin.x + (CGFloat(i) * radius + CGFloat(i) * 1.5) + 0.25, rect.origin.y + 0.25, radius - 0.5, radius - 0.5)
                let path = UIBezierPath(ovalInRect: iRect)
                UIColor.whiteColor().setStroke()
                path.lineWidth = 0.5
                path.stroke()
            }
        }
    }
    
    var strength: Int = 5 {
        willSet(newStrength) {
            self.setNeedsDisplay()
        }
    }
    
}