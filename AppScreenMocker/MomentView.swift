//
//  MomentView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/17/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material
import SnapKit

class MomentView: UITableViewCell {
        
    let hostAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.HostAvatar.rawValue
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let hostName: UILabel = {
        let label = UILabel()
        label.tag = ViewID.HostName.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff465783)
        label.font = UIFont.boldSystemFontOfSize(15.5)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.BodyLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff222222)
        label.font = UIFont.systemFontOfSize(15.5)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let singlePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.SinglePhoto.rawValue
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = MaterialColor.black
        return imageView
    }()
    
    let multiplePhotos: UIView = {
        let photoGridView = UIView()
        return photoGridView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.LocationLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff5b6a92)
        label.font = UIFont.systemFontOfSize(12)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.TimeLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.SourceLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let actionButton: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.MomentAction.rawValue
        imageView.image = UIImage.init(named: "WechatMomentsAction")
        return imageView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xffe7e7e6)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(hostAvatar)
        self.addSubview(hostName)
        self.addSubview(bodyLabel)
        self.addSubview(singlePhoto)
        self.addSubview(locationLabel)
        self.addSubview(timeLabel)
        self.addSubview(sourceLabel)
        self.addSubview(actionButton)
        self.addSubview(separator)
        self.updateConstraints()
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    internal var data: MomentData = MomentData() {
        didSet {
            if data.hostAvatarUrl != nil {
                let originalUrl = data.hostAvatarUrl
                UIUtils.getImageFromPath(data.hostAvatarUrl!, onComplete: { (image) in
                    if self.data.hostAvatarUrl == originalUrl {
                        self.hostAvatar.image = image
                    }
                })
            } else {
                hostAvatar.image = nil
            }
            hostName.text = data.hostName
            bodyLabel.text = data.bodyText
            if data.singlePhotoUrl != nil {
                let originalUrl = data.singlePhotoUrl
                UIUtils.getImageFromPath(data.singlePhotoUrl!, onComplete: { (image) in
                    if self.data.singlePhotoUrl == originalUrl {
                        self.singlePhoto.image = image
                        self.updateConstraints()
                    }
                })
            } else {
                singlePhoto.image = nil
            }
            singlePhoto.hidden = data.singlePhotoSize == nil
            locationLabel.text = data.locationText
            locationLabel.hidden = data.locationText == nil
            timeLabel.text = data.timeText
            sourceLabel.text = data.sourceText
            sourceLabel.hidden = data.sourceText == nil
        }
    }
    
    override func updateConstraints() {
        hostAvatar.snp_makeConstraints { make in
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self).offset(14)
            make.width.height.equalTo(40)
        }
        
        hostName.snp_makeConstraints { make in
            make.leading.equalTo(hostAvatar.snp_trailing).offset(10)
            make.top.equalTo(hostAvatar)
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        bodyLabel.snp_makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(hostName.snp_bottom).offset(6).priorityHigh()
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        if !singlePhoto.hidden {
            singlePhoto.snp_removeConstraints()
            singlePhoto.snp_makeConstraints { make in
                make.leading.equalTo(hostName)
                make.top.equalTo(bodyLabel.snp_bottom).offset(6)
                if data.singlePhotoSize != nil {
                    make.size.equalTo(data.singlePhotoSize!)
                }
            }
            
            locationLabel.snp_removeConstraints()
            timeLabel.snp_removeConstraints()
            if !locationLabel.hidden {
                locationLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp_bottom).offset(6)
                    make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
                }
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp_bottom).offset(6)
                    make.bottom.equalTo(self).inset(10)
                }
            } else {
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp_bottom).offset(6)
                    make.bottom.equalTo(self).inset(10)
                }
            }
        } else {
            singlePhoto.snp_removeConstraints()
            locationLabel.snp_removeConstraints()
            timeLabel.snp_removeConstraints()
            if !locationLabel.hidden {
                locationLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp_bottom).offset(6)
                    make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
                }
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp_bottom).offset(6)
                    make.bottom.equalTo(self).inset(10)
                }
            } else {
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp_bottom).offset(6)
                    make.bottom.equalTo(self).inset(10)
                }
            }
        }
        
        sourceLabel.snp_makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp_trailing).offset(8)
        }
        
        actionButton.snp_makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        separator.snp_makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    static func computeImageSize(instinct: CGSize?) -> CGSize {
        if instinct == nil {
            return CGSizeZero
        }
        return computeImageSize(CGSize(width: 120, height: 120), max: CGSize(width: 180, height: 180), instinct: instinct!)
    }
    
    static func computeImageSize(min: CGSize, max: CGSize, instinct: CGSize) -> CGSize {
        let aspectRatio = instinct.width / instinct.height
        var width: CGFloat = min.width
        var height: CGFloat = min.height
        if instinct.width <= min.width {
            width = min.width
            height = width / aspectRatio
        }
        
        if height <= min.height {
            width = width / (height / min.height)
            height = min.height
            width = clamp(min.width, max: max.width, instinct: width)
        }
        
        if instinct.width >= max.width {
            width = max.width
            height = width / aspectRatio
        }
        
        if height >= max.height {
            width = width / (height / max.height)
            height = max.height
            width = clamp(min.width, max: max.width, instinct: width)
        }
        
        return CGSizeMake(width, height)
    }
    
    static func clamp(min: CGFloat, max: CGFloat, instinct: CGFloat) -> CGFloat {
        if instinct < min {
            return min
        }
        if instinct > max {
            return max
        }
        return instinct
    }
}
