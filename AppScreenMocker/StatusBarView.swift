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
        label.tag = ViewId.timeLabelInStatusBar.rawValue
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = NSLocalizedString("09:41", comment: "")
        return label
    }()
    
    let signalStrengthIndicator: SignalStrengthIndicator = {
        let view = SignalStrengthIndicator()
        view.backgroundColor = UIColor.clear
        view.strength = 2;
        return view
    }()
    
    let carrierLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
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
        label.tag = ViewId.batteryLabel.rawValue
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = NSLocalizedString("49%", comment: "")
        return label
    }()
    
    let batteryImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StatusBarBattery")
        return view
    }()
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
        
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
        
        timeLabelInStatusBar.addSingleTapGesture(closure: gestureClosure)
        batteryLabel.addSingleTapGesture(closure: gestureClosure)
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func requestEdit(_ recognizer: UIGestureRecognizer) {
        guard ViewId(rawValue: recognizer.view!.tag) != nil else {
            return
        }
        
        switch recognizer.view {
        case let view where view is UILabel:
            let alert = UIAlertController(title: "编辑文字", message: ViewId(rawValue: view!.tag)?.description, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "请输入文字"
                textField.text = (view as! UILabel).text
            })
            
            alert.addAction(UIAlertAction(title: "确认", style: .default) { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if !(textField.text?.isEmpty ?? true) {
                    (view as! UILabel).text = textField.text
                }
            })
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    override func updateConstraints() {
        timeLabelInStatusBar.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        // left
        signalStrengthIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(6)
            make.width.equalTo(33.5)
            make.height.equalTo(5.5)
        }
        
        carrierLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(signalStrengthIndicator.snp.right).offset(4)
        }
        
        wifiImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(carrierLabel.snp.right).offset(6)
        }
        
        loadingImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(wifiImage.snp.right).offset(6)
        }
        
        // right
        
        batteryImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-5)
        }
        
        batteryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(batteryImage.snp.left).offset(-4)
        }
        
        bluetoothImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(batteryLabel.snp.left).offset(-6)
        }
        
        alarmImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(bluetoothImage.snp.left).offset(-6)
        }
        
        portraitImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(alarmImage.snp.left).offset(-6)
        }
        
        super.updateConstraints()
    }
}
