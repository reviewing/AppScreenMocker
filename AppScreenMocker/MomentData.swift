//
//  MomentData.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/30/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class MomentData {
    internal var hostAvatarUrl: String?
    internal var hostName: String? = "用户名"
    internal var bodyText: String? = "朋友圈消息文本内容"
    internal var singlePhotoUrl: String?
    internal var singlePhotoSize: CGSize = CGSizeMake(120, 120)
    internal var multiplePhotoUrls: [String]?
    internal var locationText: String? = "成都・地点名称"
    internal var timeText: String? = "1分钟前"
    internal var sourceText: String? = "发布来源"
}