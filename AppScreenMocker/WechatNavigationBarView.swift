//
//  TopLayoutGuide.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import SnapKit

class WechatNavigationBarView: UIView {
    
    let navigationBackIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NavigationBack")
        return view
    }()
    
    let navigationBackItem: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(16)
        label.text = NSLocalizedString("发现", comment: "")
        return label
    }()
    
    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(18.5)
        label.text = NSLocalizedString("朋友圈", comment: "")
        return label
    }()
    
    let navigationRightItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NavigationCamera")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(navigationBackIcon)
        self.addSubview(navigationBackItem)
        self.addSubview(navigationTitleLabel)
        self.addSubview(navigationRightItem)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func updateConstraints() {
        navigationBackIcon.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
        
        navigationBackItem.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(navigationBackIcon.snp_right)
        }
        
        navigationTitleLabel.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        
        navigationRightItem.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(10)
        }
        
        super.updateConstraints()
    }
}
