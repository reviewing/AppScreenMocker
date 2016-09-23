//
//  ViewOptions.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/23/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class ViewOptions {
    var screenWidth = 375
    var screenHeight = 667
    static let statusBarHeight = 20
    static let navigationBarHeight = 43
    
    static var defaultOptions = iPhone47InchRetina
    
    static var iPhone4InchRetina: ViewOptions {
        let options = ViewOptions()
        options.screenWidth = 320
        options.screenHeight = 568
        return options
    }
    
    static var iPhone47InchRetina: ViewOptions {
        return ViewOptions()
    }
    
    static var iPhone55InchRetina: ViewOptions {
        let options = ViewOptions()
        options.screenWidth = 414
        options.screenHeight = 736
        return options
    }
}
