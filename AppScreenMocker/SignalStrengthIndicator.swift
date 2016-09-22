//
//  SignalStrengthIndicator.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class SignalStrengthIndicator: UIView {
    
    override func draw(_ rect: CGRect) {
        let radius = (rect.width - 6) / 5;
        
        for i in 0..<5 {
            if i < strength {
                let iRect: CGRect = CGRect(x: rect.origin.x + (CGFloat(i) * radius + CGFloat(i) * 1.5), y: rect.origin.y, width: radius, height: radius)
                let path = UIBezierPath(ovalIn: iRect)
                UIColor.white.setFill()
                path.fill()
            } else {
                let iRect: CGRect = CGRect(x: rect.origin.x + (CGFloat(i) * radius + CGFloat(i) * 1.5) + 0.25, y: rect.origin.y + 0.25, width: radius - 0.5, height: radius - 0.5)
                let path = UIBezierPath(ovalIn: iRect)
                UIColor.white.setStroke()
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
