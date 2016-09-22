//
//  UIView+Gestures.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/16/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

extension UIView {
    func addSingleTapGesture(_ target: AnyObject?, action: Selector, recursively: Bool = false) {
        let singleTap = UITapGestureRecognizer(target: target, action:action)
        singleTap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
        
        if recursively {
            for view in self.subviews {
                view.addSingleTapGesture(target, action: action, recursively: true)
            }
        }
    }
    
    func addSingleTapGesture(_ recursively: Bool = false, closure: @escaping ((_ recognizer: UIGestureRecognizer) -> ())) {
        let singleTap = UITapGestureRecognizer(closure)
        singleTap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
        
        if recursively {
            for view in self.subviews {
                view.addSingleTapGesture(true, closure: closure)
            }
        }
    }
}

// Global array of targets, as extensions cannot have non-computed properties
private var target = [Target]()

extension UIGestureRecognizer {
    
    convenience init(_ closure: @escaping ((_ recognizer: UIGestureRecognizer) -> ())) {
        // let UIGestureRecognizer do its thing
        self.init()
        
        target.append(Target(self, closure))
        self.addTarget(target.last!, action: #selector(Target.invoke))
    }
}

private class Target {
    
    // store closure
    fileprivate var trailingClosure: ((_ recognizer: UIGestureRecognizer) -> ())
    fileprivate var recognizer: UIGestureRecognizer!
    
    init(_ recognizer: UIGestureRecognizer, _ closure:@escaping ((_ recognizer: UIGestureRecognizer) -> ())) {
        trailingClosure = closure
        self.recognizer = recognizer
    }
    
    // function that gesture calls, which then
    // calls closure
    /* Note: Note sure why @IBAction is needed here */
    @objc @IBAction func invoke() {
        trailingClosure(recognizer)
    }
}
