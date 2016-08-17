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
import QuartzCore

class WechatMomentsController: UIViewController {
    
    var didSetupConstraints = false
    
    var currentImageView: UIImageView?
    
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
        
        self.navigationItem.backBarButtonItem = nil
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(mockRootView)
        mockRootView.addSubview(statusBarView)
        mockRootView.addSubview(navigationBarView)
        mockRootView.addSubview(coverImage)
        coverImage.addSingleTapGesture(self, action: #selector(WechatMomentsController.requestImagePicker(_:)))
        
        mockRootView.addSubview(avatarImageBg)
        avatarImageBg.addSubview(avatarImage)
        avatarImage.addSingleTapGesture(self, action: #selector(WechatMomentsController.requestImagePicker(_:)))

        mockRootView.addSubview(usernameLabel)

        mockRootView.addSubview(momentView)
        mockRootView.addSubview(momentView2)
        mockRootView.addSubview(momentView3)
        view.setNeedsUpdateConstraints()
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    let mockRootView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view;
    }()
    
    let statusBarView: StatusBarView = {
        let view = StatusBarView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xf0222222)
        return view
    }()
    
    let navigationBarView: UIView = {
        let view = WechatNavigationBarView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xf0222222)
        return view
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    func requestImagePicker(recognizer: UITapGestureRecognizer) {
        currentImageView = recognizer.view as? UIImageView
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    let avatarImageBg: UIView = {
        let view = UIView()
        view.backgroundColor = MaterialColor.white
        view.layer.borderColor = MaterialColor.grey.base.CGColor;
        view.layer.borderWidth = 0.5;
        return view
    }()
    
    let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = MaterialColor.black
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIUtils.UIColorFromARGB(0xfffffdf1)
        label.font = UIFont.boldSystemFontOfSize(18)
        label.text = NSLocalizedString("段弘", comment: "")
        label.shadowColor = MaterialColor.black;
        label.shadowOffset = CGSizeMake(0, 1);
        return label
    }()
    
    let momentView: MomentView = {
        let view = MomentView()
        return view
    }()
    
    let momentView2: MomentView = {
        let view = MomentView()
        return view
    }()
 
    let momentView3: MomentView = {
        let view = MomentView()
        return view
    }()

    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            scrollView.snp_makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsetsZero)
            }
            
            mockRootView.snp_makeConstraints { make in
                make.edges.equalTo(scrollView).inset(UIEdgeInsetsZero)
                make.width.equalTo(375)
                make.height.equalTo(667)
            }
            
            statusBarView.snp_makeConstraints { make in
                make.top.equalTo(mockRootView)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
                make.height.equalTo(20)
            }
            
            navigationBarView.snp_makeConstraints { make in
                make.top.equalTo(statusBarView.snp_bottom)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
                make.height.equalTo(44)
            }
            
            coverImage.snp_makeConstraints { make in
                make.top.equalTo(navigationBarView.snp_bottom)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
                make.height.equalTo(255)
            }
            
            avatarImageBg.snp_makeConstraints { make in
                make.bottom.equalTo(coverImage.snp_bottom).inset(-24)
                make.trailing.equalTo(mockRootView).inset(12)
                make.width.equalTo(74)
                make.height.equalTo(74)
            }
            
            avatarImage.snp_makeConstraints { make in
                make.center.equalTo(avatarImageBg)
                make.width.equalTo(70)
                make.height.equalTo(70)
            }
            
            usernameLabel.snp_makeConstraints { make in
                make.bottom.equalTo(coverImage.snp_bottom).inset(11)
                make.right.equalTo(avatarImageBg.snp_left).inset(-22)
            }
            
            momentView.snp_makeConstraints { make in
                make.top.equalTo(avatarImageBg.snp_bottom).offset(32)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
            }
            
            momentView2.snp_makeConstraints { make in
                make.top.equalTo(momentView.snp_bottom)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
            }
            
            momentView3.snp_makeConstraints { make in
                make.top.equalTo(momentView2.snp_bottom)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

extension WechatMomentsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        currentImageView?.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}