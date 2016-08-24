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

class MomentView: UIView {
        
    let hostAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.HostAvatar.rawValue
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let hostName: UILabel = {
        let label = UILabel()
        label.tag = ViewID.HostName.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff465783)
        label.font = UIFont.boldSystemFontOfSize(15.5)
        label.text = NSLocalizedString("用户名", comment: "")
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.TextLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff222222)
        label.font = UIFont.systemFontOfSize(15.5)
        label.text = NSLocalizedString("朋友圈消息文本内容", comment: "")
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let singlePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.MomentPhoto.rawValue
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = MaterialColor.black
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.LocationLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff5b6a92)
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("成都・地点名称", comment: "")
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.TimeLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("1分钟前", comment: "")
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.SourceLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("发布来源", comment: "")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(hostAvatar)
        self.addSubview(hostName)
        self.addSubview(textLabel)
        self.addSubview(singlePhoto)
        self.addSubview(locationLabel)
        self.addSubview(timeLabel)
        self.addSubview(sourceLabel)
        self.addSubview(actionButton)
        self.addSubview(separator)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
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
        
        textLabel.snp_makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(hostName.snp_bottom).offset(6).priorityHigh()
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        singlePhoto.snp_makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(textLabel.snp_bottom).offset(6)
            make.width.greaterThanOrEqualTo(120).priorityHigh()
            make.width.lessThanOrEqualTo(self.superview!).multipliedBy(0.48).priorityHigh()
            make.height.greaterThanOrEqualTo(80).priorityHigh()
            make.height.lessThanOrEqualTo(self.superview!).multipliedBy(0.27).priorityHigh()
            let instinctSize = singlePhoto.intrinsicContentSize();
            if instinctSize.height > 0 && instinctSize.width > 0 {
                make.width.equalTo(singlePhoto.snp_height).multipliedBy(CGFloat(instinctSize.width) / instinctSize.height)
            }
        }
        
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
}
