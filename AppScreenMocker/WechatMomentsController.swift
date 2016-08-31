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
import Toast_Swift

class WechatMomentsController: UIViewController, MaterialSwitchDelegate {
    
    var didSetupConstraints = false
    
    var currentImageView: UIImageView?
    private var switchControl: MaterialSwitch!
    private var editToggleButton: FlatButton!
    private var flatMenu: Menu!

    private var momentDataSource: Array<MomentData>!
    private var momentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSwitchControl()
        prepareEditToggleButton()
        prepareNavigationItem()
        prepareTableView()
        prepareView()
        prepareFlatMenu()
    }
    
    private func prepareSwitchControl() {
        switchControl = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
        switchControl.buttonOnColor = MaterialColor.green.darken2
        switchControl.trackOnColor = MaterialColor.green.lighten3
        switchControl.buttonOffColor = MaterialColor.green.lighten4
        switchControl.trackOffColor = MaterialColor.green.lighten3
        switchControl.delegate = self
    }
    
    func materialSwitchStateChanged(control: MaterialSwitch) {
        self.view.makeToast(control.on ? "编辑模式" : "正常模式", duration: 1.0, position: .Bottom)
        editToggleButton.setTitle(control.on ? "编辑模式" : "正常模式", forState: .Normal)
        if control.on {
            self.flatMenu.views![0].hidden = false;
        } else {
            if self.flatMenu.opened {
                self.flatMenu.close() { [unowned self] (view: UIView) in
                    self.flatMenu.views![0].hidden = true;
                }
            } else {
                self.flatMenu.views![0].hidden = true;
            }
        }
    }
    
    private func prepareEditToggleButton() {
        let w: CGFloat = 200
        editToggleButton = FlatButton(frame: CGRectMake((view.bounds.width - w) / 2, 100, w, 48))
        editToggleButton.setTitle("正常模式", forState: .Normal)
        editToggleButton.setTitleColor(MaterialColor.white, forState: .Normal)
        editToggleButton.pulseColor = MaterialColor.white
        editToggleButton.addTarget(.TouchUpInside) { [unowned self] in
            self.switchControl.toggle()
        }
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "朋友圈"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        self.navigationItem.backBarButtonItem = nil
        navigationItem.rightControls = [switchControl, editToggleButton]
    }
    
    private func prepareFlatMenu() {
        let btn1: FlatButton = FlatButton()
        btn1.addTarget(.TouchUpInside) { [unowned self] in
            if self.flatMenu.enabled {
                if self.flatMenu.opened {
                    self.flatMenu.close()
                } else {
                    self.flatMenu.open()
                }
            }
        }
        btn1.setTitleColor(MaterialColor.white, forState: .Normal)
        btn1.backgroundColor = MaterialColor.green.darken1
        btn1.pulseColor = MaterialColor.white
        btn1.setTitle("选项", forState: .Normal)
        btn1.hidden = true
        view.addSubview(btn1)
        
        let btn2: FlatButton = FlatButton()
        btn2.addTarget(.TouchUpInside) { [unowned self] in
            self.toggleCoverVisiblity()
            btn2.setTitle(self.coverImage.hidden ? "显示封面栏" :"隐藏封面栏", forState: .Normal)
        }
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.backgroundColor = MaterialColor.green.darken1
        btn2.pulseColor = MaterialColor.white
        btn2.setTitle("隐藏封面栏", forState: .Normal)
        view.addSubview(btn2)
        
        let btn3: FlatButton = FlatButton()
        btn3.setTitleColor(MaterialColor.white, forState: .Normal)
        btn3.backgroundColor = MaterialColor.green.darken1
        btn3.pulseColor = MaterialColor.white
        btn3.setTitle("添加消息", forState: .Normal)
        view.addSubview(btn3)
        
        let spacing: CGFloat = 24
        let width: CGFloat = 128
        let height: CGFloat = 36
        flatMenu = Menu(origin: CGPointMake((view.bounds.width - width) / 2, spacing))
        flatMenu.direction = .Down
        flatMenu.spacing = 8
        flatMenu.itemSize = CGSizeMake(width, height)
        flatMenu.views = [btn1, btn2, btn3]
    }
    
    private func prepareTableView() {
        momentDataSource = [MomentData]()
        for _ in 0..<10 {
            momentDataSource.append(MomentData())
        }
        
        momentTableView = UITableView()
        momentTableView.registerClass(MomentView.self, forCellReuseIdentifier: "MomentViewCell")
        momentTableView.dataSource = self
        momentTableView.delegate = self
        momentTableView.scrollEnabled = false
        momentTableView.tableFooterView = UIView()
        momentTableView.separatorStyle = .None
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(mockRootView)
        mockRootView.addSubview(statusBarView)
        mockRootView.addSubview(navigationBarView)
        
        mockRootView.addSubview(coverImage)
        mockRootView.addSubview(avatarImageBg)
        avatarImageBg.addSubview(avatarImage)
        mockRootView.addSubview(selfNameLabel)

        mockRootView.addSubview(momentTableView)
        
        view.addSingleTapGesture(true) {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
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
        imageView.tag = ViewID.CoverImage.rawValue
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let avatarImageBg: UIView = {
        let view = UIView()
        view.backgroundColor = MaterialColor.white
        view.layer.borderColor = MaterialColor.grey.base.CGColor;
        view.layer.borderWidth = 0.5;
        return view
    }()
    
    let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.AvatarImage.rawValue
        imageView.backgroundColor = MaterialColor.black
        return imageView
    }()
    
    let selfNameLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.SelfNameLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xfffffdf1)
        label.font = UIFont.boldSystemFontOfSize(18)
        label.text = NSLocalizedString("用户名", comment: "")
        label.shadowColor = MaterialColor.black;
        label.shadowOffset = CGSizeMake(0, 1);
        return label
    }()

    func requestEdit(recognizer: UIGestureRecognizer) {
        if switchControl.on {
            let id = ViewID(rawValue: recognizer.view!.tag);
            
            if id == nil {
                return
            }
            
            switch id! {
            case .LocationLabel, .SourceLabel, .SinglePhoto:
                recognizer.view!.hidden = true
                recognizer.view!.superview?.updateConstraints()
            case .SelfNameLabel, .CoverImage, .AvatarImage:
                toggleCoverVisiblity()
                break
            default:
                break
            }
            return
        }
        
        switch recognizer.view {
        case let view where view is UIImageView && ViewID(rawValue: view!.tag)?.actionHint == 1:
            currentImageView = recognizer.view as? UIImageView
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        case let view where view is UILabel && view!.tag != 0:
            let alert = UIAlertController(title: "编辑文字", message: ViewID(rawValue: view!.tag)?.description, preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "请输入文字"
            })
            
            alert.addAction(UIAlertAction(title: "确认", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if !(textField.text?.isEmpty ?? true) {
                    (view as! UILabel).text = textField.text
                    
                    let momentView = view?.superview as! MomentView
                    let indexPath = self.momentTableView.indexPathForCell(momentView)
                    
                    let id = ViewID(rawValue: recognizer.view!.tag);
                    
                    if id == nil || indexPath == nil {
                        return
                    }
                    
                    switch id! {
                    case .HostName:
                        self.momentDataSource[indexPath!.row].hostName = textField.text
                    case .BodyLabel:
                        self.momentDataSource[indexPath!.row].bodyText = textField.text
                    case .LocationLabel:
                        self.momentDataSource[indexPath!.row].locationText = textField.text
                    case .TimeLabel:
                        self.momentDataSource[indexPath!.row].timeText = textField.text
                    case .SourceLabel:
                        self.momentDataSource[indexPath!.row].sourceText = textField.text
                    default:
                        break
                }
            }}))
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        default:
            break
        }
    }

    func toggleCoverVisiblity() {
        let hidden = coverImage.hidden
        selfNameLabel.hidden = !hidden
        coverImage.hidden = !hidden
        avatarImage.hidden = !hidden
        avatarImageBg.hidden = !hidden
        
        didSetupConstraints = false
        updateViewConstraints()
    }
    
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
            
            if !coverImage.hidden {
                coverImage.snp_removeConstraints()
                avatarImageBg.snp_removeConstraints()
                avatarImage.snp_removeConstraints()
                selfNameLabel.snp_removeConstraints()
                momentTableView.snp_removeConstraints()

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
                
                selfNameLabel.snp_makeConstraints { make in
                    make.bottom.equalTo(coverImage.snp_bottom).inset(11)
                    make.right.equalTo(avatarImageBg.snp_left).inset(-22)
                }
                
                momentTableView.snp_makeConstraints { make in
                    make.top.equalTo(avatarImageBg.snp_bottom).offset(32)
                    make.leading.equalTo(mockRootView)
                    make.trailing.equalTo(mockRootView)
                    make.bottom.equalTo(mockRootView)
                }
            } else {
                coverImage.snp_removeConstraints()
                avatarImageBg.snp_removeConstraints()
                avatarImage.snp_removeConstraints()
                selfNameLabel.snp_removeConstraints()
                momentTableView.snp_removeConstraints()
                
                momentTableView.snp_makeConstraints { make in
                    make.top.equalTo(navigationBarView.snp_bottom)
                    make.leading.equalTo(mockRootView)
                    make.trailing.equalTo(mockRootView)
                    make.bottom.equalTo(mockRootView)
                }
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

extension WechatMomentsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        self.dismissViewControllerAnimated(true, completion: nil)
        if currentImageView == nil {
            return
        }
        
        let momentView = currentImageView?.superview as? MomentView
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if momentView == nil {
            currentImageView!.image = image
            return
        }
        
        let indexPath = self.momentTableView.indexPathForCell(momentView!)
        
        let id = ViewID(rawValue: currentImageView!.tag);
        
        if id == nil || indexPath == nil {
            return
        }
        
        switch id! {
        case .HostAvatar:
            self.momentDataSource[indexPath!.row].hostAvatarUrl = (info[UIImagePickerControllerReferenceURL] as? NSURL)?.absoluteString
        case .SinglePhoto:
            self.momentDataSource[indexPath!.row].singlePhotoUrl = (info[UIImagePickerControllerReferenceURL] as? NSURL)?.absoluteString
            self.momentDataSource[indexPath!.row].singlePhotoSize = MomentView.computeImageSize(image?.size)
        default:
            break
        }
        momentTableView.reloadData()
    }
}

extension WechatMomentsController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentDataSource.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MomentView = MomentView(style: .Default, reuseIdentifier: "MomentViewCell")
        cell.addSingleTapGesture(true) {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
        cell.data = momentDataSource[indexPath.row]
        return cell
    }
}

extension WechatMomentsController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}