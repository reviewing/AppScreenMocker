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
        view.addSubview(scrollView)
        scrollView.addSubview(mockRootView)
        mockRootView.addSubview(topLayoutGuideView)

        view.setNeedsUpdateConstraints()
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    let mockRootView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteColor()
        return view;
    }()
    
    
    let topLayoutGuideView: UIView = {
        let view = TopLayoutGuide()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xf0222222)
        return view
    }()
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            scrollView.snp_makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsetsMake(10, 0, 0, 0))
            }
            
            mockRootView.snp_makeConstraints { make in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView)
            }
            
            topLayoutGuideView.snp_makeConstraints { make in
                make.top.equalTo(mockRootView)
                make.left.equalTo(mockRootView)
                make.right.equalTo(mockRootView)
                make.height.equalTo(64)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

}