//
//  ViewID.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/23/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import Foundation

enum ViewID: Int {
    case rootView = 1, hostAvatar, hostName, bodyLabel, locationLabel, timeLabel, sourceLabel, selfNameLabel, coverImage, avatarImage, momentAction, bodyPhoto
    
    var description: String {
        switch self {
        case .rootView:
            return "根视图"
        case .hostAvatar:
            return "发布者头像"
        case .hostName:
            return "发布者用户名"
        case .bodyLabel:
            return "文字内容"
        case .locationLabel:
            return "地点"
        case .timeLabel:
            return "发布时间"
        case .sourceLabel:
            return "发布来源"
        case .selfNameLabel:
            return "用户名"
        case .coverImage:
            return "封面图片"
        case .avatarImage:
            return "用户头像"
        case .momentAction:
            return "赞和评论"
        case .bodyPhoto:
            return "图片内容"
        }
    }
    
    var actionHint: Int {
        switch self {
        case .hostAvatar, .coverImage, .avatarImage, .bodyPhoto:
            return 1
        default:
            return 0
        }
    }
}
