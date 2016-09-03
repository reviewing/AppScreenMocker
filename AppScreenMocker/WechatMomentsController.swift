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
        editToggleButton.setTitle(control.on ? "完成" : "编辑", forState: .Normal)
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
        let w: CGFloat = 100
        editToggleButton = FlatButton(frame: CGRectMake((view.bounds.width - w) / 2, 0, w, 48))
        editToggleButton.setTitle("编辑", forState: .Normal)
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
    
    let action1: FlatButton = {
        let button = FlatButton()
        button.setTitleColor(MaterialColor.white, forState: .Normal)
        button.backgroundColor = MaterialColor.green.darken1
        button.pulseColor = MaterialColor.white
        button.setTitle("隐藏封面", forState: .Normal)
        return button
    }()
    
    let action2: FlatButton = {
        let button = FlatButton()
        button.setTitleColor(MaterialColor.white, forState: .Normal)
        button.backgroundColor = MaterialColor.green.darken1
        button.pulseColor = MaterialColor.white
        button.setTitle("添加消息", forState: .Normal)
        return button
    }()
    
    let spacing: CGFloat = 8
    let menuItemWidth: CGFloat = (UIScreen.mainScreen().bounds.width - 4 * 8) / 3
    let menuItemHeight: CGFloat = 36
    
    private func prepareFlatMenu() {
        action1.addTarget(.TouchUpInside) { [unowned self] in
            self.toggleCoverVisiblity()
            self.action1.setTitle(self.coverImage.hidden ? "显示封面" :"隐藏封面", forState: .Normal)
        }
        view.addSubview(action1)
        action2.addTarget(.TouchUpInside) { [unowned self] in
            var lastVisibleRow = self.momentTableView.indexPathsForVisibleRows?.last?.row ?? -1
            self.momentDataSource.append(MomentData())
            self.momentTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: lastVisibleRow + 1, inSection: 0)], withRowAnimation: .Fade)
            lastVisibleRow = self.momentTableView.indexPathsForVisibleRows?.last?.row ?? -1
            if self.momentDataSource.count > lastVisibleRow + 1 {
                self.momentDataSource.removeLast()
                self.momentTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: lastVisibleRow + 1, inSection: 0)], withRowAnimation: .None)
                self.view.makeToast("一屏已经显示不下啦！", duration: 1.0, position: .Bottom)
            }
        }
        view.addSubview(action2)
        
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
        btn1.setTitle("更多", forState: .Normal)
        view.addSubview(btn1)
        
        let btn2: FlatButton = FlatButton()
        btn2.addTarget(.TouchUpInside) { [unowned self] in
            self.toggleCoverVisiblity()
            btn2.setTitle(self.coverImage.hidden ? "显示封面" :"隐藏封面", forState: .Normal)
        }
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.backgroundColor = MaterialColor.green.darken1
        btn2.pulseColor = MaterialColor.white
        btn2.setTitle("隐藏封面", forState: .Normal)
        view.addSubview(btn2)
        
        let btn3: FlatButton = FlatButton()
        btn3.addTarget(.TouchUpInside) { [unowned self] in
            var lastVisibleRow = self.momentTableView.indexPathsForVisibleRows?.last?.row ?? -1
            self.momentDataSource.append(MomentData())
            self.momentTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: lastVisibleRow + 1, inSection: 0)], withRowAnimation: .Fade)
            lastVisibleRow = self.momentTableView.indexPathsForVisibleRows?.last?.row ?? -1
            if self.momentDataSource.count > lastVisibleRow + 1 {
                self.momentDataSource.removeLast()
                self.momentTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: lastVisibleRow + 1, inSection: 0)], withRowAnimation: .None)
                self.view.makeToast("一屏已经显示不下啦！", duration: 1.0, position: .Bottom)
            }
        }
        btn3.setTitleColor(MaterialColor.white, forState: .Normal)
        btn3.backgroundColor = MaterialColor.green.darken1
        btn3.pulseColor = MaterialColor.white
        btn3.setTitle("添加消息", forState: .Normal)
        view.addSubview(btn3)
        
        flatMenu = Menu(origin: CGPointMake(view.bounds.width - menuItemWidth - spacing, spacing))
        flatMenu.direction = .Down
        flatMenu.spacing = spacing
        flatMenu.itemSize = CGSizeMake(menuItemWidth, menuItemHeight)
        flatMenu.views = [btn1, btn2, btn3]
    }
    
    private func prepareTableView() {
        momentDataSource = [MomentData]()
        for _ in 0..<1 {
            momentDataSource.append(MomentData())
        }
        
        momentTableView = UITableView()
        momentTableView.registerClass(MomentView.self, forCellReuseIdentifier: "MomentViewCell")
        momentTableView.dataSource = self
        momentTableView.delegate = self
        momentTableView.scrollEnabled = false
        momentTableView.tableFooterView = UIView()
        momentTableView.separatorStyle = .None
        momentTableView.allowsSelection = false
    }
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }

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
        
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }

        coverImage.addSingleTapGesture(closure: gestureClosure)
        avatarImage.addSingleTapGesture(closure: gestureClosure)
        selfNameLabel.addSingleTapGesture(closure: gestureClosure)

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
        let id = ViewID(rawValue: recognizer.view!.tag);
        if id == nil {
            return
        }
        
        if switchControl.on {
            switch id! {
            case .LocationLabel, .SourceLabel, .BodyPhoto:
                let alert = UIAlertController(title: id!.description, message: ViewID(rawValue: view!.tag)?.description, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "移除" + id!.description, style: .Default) { (action) -> Void in
                    let indexPath = self.findIndexPathOfView(recognizer.view)
                    if indexPath == nil {
                        return
                    }
                    
                    switch id! {
                    case .LocationLabel:
                        self.momentDataSource[indexPath!.row].locationText = nil
                    case .SourceLabel:
                        self.momentDataSource[indexPath!.row].sourceText = nil
                    case .BodyPhoto:
                        let index = self.findIndexOfImageView(recognizer.view as? UIImageView, indexPath: indexPath)
                        if index >= 0 {
                            self.momentDataSource[indexPath!.row].photoUrls.removeAtIndex(index)
                        }
                    default:
                        break
                    }
                    
                    self.momentTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                })
                alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            case .SelfNameLabel, .CoverImage, .AvatarImage:
                let alert = UIAlertController(title: "封面", message: ViewID(rawValue: view!.tag)?.description, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "隐藏封面", style: .Default) { (action) -> Void in
                    self.toggleCoverVisiblity()
                })
                alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            default:
                break
            }
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
            
            alert.addAction(UIAlertAction(title: "确认", style: .Default) { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if !(textField.text?.isEmpty ?? true) {
                    (view as! UILabel).text = textField.text
                    
                    let indexPath = self.findIndexPathOfView(view!.superview)
                    if indexPath == nil {
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
                }
            })
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        case let view where id! == .MomentAction:
            guard let indexPath = self.findIndexPathOfView(view!.superview) else {
                return
            }
            let alert = UIAlertController(title: "编辑消息", message: nil, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "添加图片", style: .Default) { (action) -> Void in
                self.momentDataSource[indexPath.row].singlePhotoSize = MomentData.defaultSinglePhotoSize
                if self.momentDataSource[indexPath.row].photoUrls.count < 9 {
                    self.momentDataSource[indexPath.row].photoUrls.append(NSURL())
                    self.momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                } else {
                    self.view.makeToast("最多只能添加9张图片", duration: 1.0, position: .Bottom)
                }
                })
            alert.addAction(UIAlertAction(title: "显示地点", style: .Default) { (action) -> Void in
                self.momentDataSource[indexPath.row].locationText = MomentData.defaultLocationText
                self.momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "显示来源", style: .Default) { (action) -> Void in
                self.momentDataSource[indexPath.row].sourceText = MomentData.defaultSourceText
                self.momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "显示赞", style: .Default) { (action) -> Void in
                })
            alert.addAction(UIAlertAction(title: "显示评论", style: .Default) { (action) -> Void in
                })
            alert.addAction(UIAlertAction(title: "移除该条朋友圈", style: .Destructive) { (action) -> Void in
                self.momentDataSource.removeAtIndex(indexPath.row)
                self.momentTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
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
            
            action1.snp_makeConstraints { make in
                make.left.equalTo(view).offset(8)
                make.top.equalTo(view).offset(8)
                make.width.equalTo(menuItemWidth)
                make.height.equalTo(menuItemHeight)
            }
            
            action2.snp_makeConstraints { make in
                make.left.equalTo(action1.snp_right).offset(8)
                make.top.equalTo(view).offset(8)
                make.width.equalTo(menuItemWidth)
                make.height.equalTo(menuItemHeight)
            }
            
            scrollView.snp_makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsetsMake(52, 0, 0, 0))
            }
            
            mockRootView.snp_makeConstraints { make in
                make.top.equalTo(scrollView)
                make.centerX.equalTo(scrollView)
                make.bottom.equalTo(scrollView)
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
    
    func findIndexPathOfView(view: UIView?) -> NSIndexPath? {
        var v: UIView? = view
        while v != nil {
            if v is MomentView {
                break
            }
            v = v!.superview
        }
        
        if v == nil {
            return nil
        }
        
        let momentView = v as! MomentView
        let indexPath = self.momentTableView.indexPathForCell(momentView)
        return indexPath
    }
    
    func findIndexOfImageView(imageView: UIImageView?, indexPath: NSIndexPath?) -> Int {
        if imageView == nil || indexPath == nil {
            return -1;
        }
        let momentView = self.momentTableView.cellForRowAtIndexPath(indexPath!) as? MomentView
        if imageView === momentView?.singlePhoto {
            return 0;
        }
        if momentView == nil {
            return -1
        }
        return momentView!.multiplePhotos.imageViews.indexOf(imageView!) ?? -1
    }
}

extension WechatMomentsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        self.dismissViewControllerAnimated(true, completion: nil)
        if currentImageView == nil {
            return
        }
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        guard let indexPath = findIndexPathOfView(currentImageView) else {
            currentImageView!.image = image
            return
        }
        
        let id = ViewID(rawValue: currentImageView!.tag);
        
        if id == nil {
            return
        }
        
        guard let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL else {
            return
        }
        
        switch id! {
        case .HostAvatar:
            self.momentDataSource[indexPath.row].hostAvatarUrl = imageUrl
        case .BodyPhoto:
            let index = self.findIndexOfImageView(currentImageView, indexPath: indexPath)
            if index >= 0 {
                self.momentDataSource[indexPath.row].photoUrls[index] = imageUrl
                if self.momentDataSource[indexPath.row].photoUrls.count == 1 {
                    self.momentDataSource[indexPath.row].singlePhotoSize = MomentView.computeImageSize(image?.size)
                }
            }
        default:
            break
        }
        momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
        cell.data = momentDataSource[indexPath.row]
        for view in cell.subviews where view.tag != 0 {
            view.addSingleTapGesture(true, closure: gestureClosure)
        }
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