//
//  MomentData.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/30/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class MomentData {
    static let defaultHostName = "科比"
    static let defaultBodyText = "我与詹姆斯私交甚好"
    static let defaultSinglePhotoSize = CGSizeMake(120, 120)
    static let defaultLocationText = "成都・成都体育中心"
    static let defaultTimeText = "1分钟前"
    static let defaultSourceText = "新浪体育"

    internal var hostAvatarUrl: NSURL?
    internal var hostName: String? = defaultHostName
    internal var bodyText: String? = defaultBodyText
    internal var singlePhotoSize: CGSize? = defaultSinglePhotoSize
    internal var photoUrls: [NSURL] = []
    internal var locationText: String? = defaultLocationText
    internal var timeText: String? = defaultTimeText
    internal var sourceText: String? = defaultSourceText
    internal var likes: [Like] = []
    internal var comments: [Comment] = []
}