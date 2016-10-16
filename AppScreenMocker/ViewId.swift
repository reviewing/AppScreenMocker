//
//  ViewId.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 10/16/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import Foundation

enum ViewId: Int {
    case rootView = 1, timeLabelInStatusBar, batteryLabel
    
    var description: String {
        switch self {
        case .rootView:
            return "根视图"
        case .timeLabelInStatusBar:
            return "状态栏时间"
        case .batteryLabel:
            return "电量百分比"
        }
    }
}
