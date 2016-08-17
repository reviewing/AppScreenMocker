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
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let hostName: UILabel = {
        let label = UILabel()
        label.textColor = UIUtils.UIColorFromARGB(0xff465783)
        label.font = UIFont.boldSystemFontOfSize(15.5)
        label.text = NSLocalizedString("段弘", comment: "")
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIUtils.UIColorFromARGB(0xff222222)
        label.font = UIFont.systemFontOfSize(15.5)
        label.text = NSLocalizedString("你好呀世界，今天我要回家了，希望一路顺利吧！祝大家健康幸福。", comment: "")
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIUtils.UIColorFromARGB(0xff5b6a92)
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("广安・武胜县国税局", comment: "")
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("1分钟前", comment: "")
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("弘哥保护你", comment: "")
        return label
    }()
    
    let actionButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "WechatMomentsAction")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(hostAvatar)
        self.addSubview(hostName)
        self.addSubview(textLabel)
        self.addSubview(locationLabel)
        self.addSubview(timeLabel)
        self.addSubview(sourceLabel)
        self.addSubview(actionButton)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func updateConstraints() {
        hostAvatar.snp_makeConstraints { make in
            make.left.equalTo(self).offset(10)
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
        
        locationLabel.snp_makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(textLabel.snp_bottom).offset(6)
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
        
        super.updateConstraints()
    }
}
