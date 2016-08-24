//
//  ViewID.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/23/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import Foundation

enum ViewID: Int {
    case HostAvatar = 1, HostName, TextLabel, LocationLabel, TimeLabel, SourceLabel, SelfNameLabel, CoverImage, AvatarImage, MomentAction, MomentPhoto
    
    var description: String {
        switch self {
        case .HostAvatar:
            return "发布者头像"
        case .HostName:
            return "发布者用户名"
        case .TextLabel:
            return "文字内容"
        case .LocationLabel:
            return "地点"
        case .TimeLabel:
            return "发布时间"
        case .SourceLabel:
            return "发布来源"
        case .SelfNameLabel:
            return "用户名"
        case .CoverImage:
            return "封面图片"
        case .AvatarImage:
            return "用户头像"
        case .MomentAction:
            return "赞和评论"
        case .MomentPhoto:
            return "图片内容"
        }
    }
    
    var actionHint: Int {
        switch self {
        case .HostAvatar, .CoverImage, .AvatarImage, .MomentPhoto:
            return 1
        default:
            return 0
        }
    }
}
