//
//  WechatMomentsController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material
import SnapKit

class WechatMomentsController: UIViewController {
    
    var didSetupConstraints = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        prepareView()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "朋友圈"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        view.addSubview(mockRootView)
        mockRootView.addSubview(topLayoutGuideView)
        topLayoutGuideView.addSubview(statusBarView)
        statusBarView.addSubview(timeLabelInStatusBar)
        statusBarView.addSubview(signalStrengthIndicator)
        statusBarView.addSubview(carrierLabel)

        view.setNeedsUpdateConstraints()
    }
    
    let mockRootView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteColor()
        return view;
    }()
    
    
    let topLayoutGuideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xf0222222)
        return view
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        return view
    }()
    
    let timeLabelInStatusBar: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.font = UIFont.boldSystemFontOfSize(12)
        label.text = NSLocalizedString("9:41", comment: "")
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
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            mockRootView.snp_makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsetsMake(10, 0, 0, 0))
            }
            
            topLayoutGuideView.snp_makeConstraints { make in
                make.top.equalTo(mockRootView)
                make.left.equalTo(mockRootView)
                make.right.equalTo(mockRootView)
                make.height.equalTo(64)
            }
            
            statusBarView.snp_makeConstraints { make in
                make.top.equalTo(topLayoutGuideView)
                make.left.equalTo(topLayoutGuideView)
                make.right.equalTo(topLayoutGuideView)
                make.height.equalTo(20)
            }
            
            timeLabelInStatusBar.snp_makeConstraints { make in
                make.center.equalTo(statusBarView)
            }
            
            signalStrengthIndicator.snp_makeConstraints { make in
                make.centerY.equalTo(statusBarView)
                make.left.equalTo(statusBarView).offset(5)
                make.width.equalTo(33.5)
                make.height.equalTo(5.5)
            }
            
            carrierLabel.snp_makeConstraints { make in
                make.centerY.equalTo(statusBarView)
                make.left.equalTo(signalStrengthIndicator.snp_right).offset(4)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

}