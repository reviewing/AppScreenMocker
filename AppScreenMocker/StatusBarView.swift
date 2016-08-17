//
//  StatusBar.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/17/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import SnapKit

class StatusBarView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timeLabelInStatusBar)
        self.addSubview(signalStrengthIndicator)
        self.addSubview(carrierLabel)
        self.addSubview(wifiImage)
        self.addSubview(loadingImage)
        self.addSubview(portraitImage)
        self.addSubview(alarmImage)
        self.addSubview(bluetoothImage)
        self.addSubview(batteryLabel)
        self.addSubview(batteryImage)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func updateConstraints() {
        timeLabelInStatusBar.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        
        // left
        signalStrengthIndicator.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(6)
            make.width.equalTo(33.5)
            make.height.equalTo(5.5)
        }
        
        carrierLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(signalStrengthIndicator.snp_right).offset(4)
        }
        
        wifiImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(carrierLabel.snp_right).offset(6)
        }
        
        loadingImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(wifiImage.snp_right).offset(6)
        }
        
        // right
        
        batteryImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-5)
        }
        
        batteryLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(batteryImage.snp_left).offset(-4)
        }
        
        bluetoothImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(batteryLabel.snp_left).offset(-6)
        }
        
        alarmImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(bluetoothImage.snp_left).offset(-6)
        }
        
        portraitImage.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(alarmImage.snp_left).offset(-6)
        }
        
        super.updateConstraints()
    }
}
