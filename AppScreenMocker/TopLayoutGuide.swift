//
//  TopLayoutGuide.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import SnapKit

class TopLayoutGuide: UIView {
    
    let statusBarView: UIView = {
        let view = UIView()
        return view
    }()
    
    let timeLabelInStatusBar: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(12)
        label.text = NSLocalizedString("09:41", comment: "")
        return label
    }()
    
    let signalStrengthIndicator: SignalStrengthIndicator = {
        let view = SignalStrengthIndicator()
        view.backgroundColor = .clearColor()
        view.strength = 2;
        return view
    }()
    
    let carrierLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("中国电信", comment: "")
        return label
        
    }()
    
    let wifiImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarWifi")
        return view
    }()
    
    let loadingImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarLoading")
        return view
    }()

    let portraitImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarPortrait")
        return view
    }()
    
    let alarmImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarAlarm")
        return view
    }()
    
    let bluetoothImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarBluetooth")
        return view
    }()
    
    let batteryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = NSLocalizedString("49%", comment: "")
        return label
    }()
    
    let batteryImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarBattery")
        return view
    }()
    
    let navigationBarView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        self.addSubview(statusBarView)
        statusBarView.addSubview(timeLabelInStatusBar)
        statusBarView.addSubview(signalStrengthIndicator)
        statusBarView.addSubview(carrierLabel)
        statusBarView.addSubview(wifiImage)
        statusBarView.addSubview(loadingImage)
        statusBarView.addSubview(portraitImage)
        statusBarView.addSubview(alarmImage)
        statusBarView.addSubview(bluetoothImage)
        statusBarView.addSubview(batteryLabel)
        statusBarView.addSubview(batteryImage)
        
        self.addSubview(navigationBarView)
        navigationBarView.addSubview(navigationBackIcon)
        navigationBarView.addSubview(navigationBackItem)
        navigationBarView.addSubview(navigationTitleLabel)
        navigationBarView.addSubview(navigationRightItem)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        statusBarView.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(20)
        }
        
        timeLabelInStatusBar.snp_makeConstraints { make in
            make.center.equalTo(statusBarView)
        }
        
        // left
        signalStrengthIndicator.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.left.equalTo(statusBarView).offset(6)
            make.width.equalTo(33.5)
            make.height.equalTo(5.5)
        }
        
        carrierLabel.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.left.equalTo(signalStrengthIndicator.snp_right).offset(4)
        }
        
        wifiImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.left.equalTo(carrierLabel.snp_right).offset(6)
        }
        
        loadingImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.left.equalTo(wifiImage.snp_right).offset(6)
        }
        
        // right
        
        batteryImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.right.equalTo(statusBarView).offset(-5)
        }
        
        batteryLabel.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.right.equalTo(batteryImage.snp_left).offset(-4)
        }

        bluetoothImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.right.equalTo(batteryLabel.snp_left).offset(-6)
        }

        alarmImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.right.equalTo(bluetoothImage.snp_left).offset(-6)
        }

        portraitImage.snp_makeConstraints { make in
            make.centerY.equalTo(statusBarView)
            make.right.equalTo(alarmImage.snp_left).offset(-6)
        }
        
        navigationBarView.snp_makeConstraints { make in
            make.top.equalTo(statusBarView.snp_bottom)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(44)
        }
        
        navigationBackIcon.snp_makeConstraints { make in
            make.centerY.equalTo(navigationBarView)
            make.left.equalTo(navigationBarView).offset(10)
        }
        
        navigationBackItem.snp_makeConstraints { make in
            make.centerY.equalTo(navigationBarView)
            make.left.equalTo(navigationBackIcon.snp_right)
        }
        
        navigationTitleLabel.snp_makeConstraints { make in
            make.center.equalTo(navigationBarView)
        }
        
        navigationRightItem.snp_makeConstraints { make in
            make.centerY.equalTo(navigationBarView)
            make.right.equalTo(navigationBarView).inset(10)
        }
    }
}
