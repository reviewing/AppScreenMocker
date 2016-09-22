//
//  WechatMomentsController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import SnapKit
import QuartzCore
import Kingfisher

class WechatMomentsController: UIViewController {
    
    var didSetupConstraints = false
    internal var editMode = false
    
    var currentImageView: UIImageView?

    fileprivate var momentDataSource: Array<MomentData>!
    fileprivate var momentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        prepareTableView()
        prepareActions()
        prepareView()
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "朋友圈"
        navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.backBarButtonItem = nil
    }
    
    let action1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("隐藏封面", for: UIControlState())
        return button
    }()
    
    let action2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加消息", for: UIControlState())
        return button
    }()
    
    let action3 = UIButton(type: .system)
    
    let spacing: CGFloat = 8
    let menuItemWidth: CGFloat = (UIScreen.main.bounds.width - 4 * 8) / 3
    let menuItemHeight: CGFloat = 36
    
    fileprivate func prepareActions() {
        action1.addTarget(.touchUpInside) { [unowned self] in
            self.toggleCoverVisiblity()
            self.action1.setTitle(self.coverImage.isHidden ? "显示封面" :"隐藏封面", for: UIControlState())
        }
        view.addSubview(action1)
        action2.addTarget(.touchUpInside) { [unowned self] in
            var lastVisibleRow = (self.momentTableView.indexPathsForVisibleRows?.last as NSIndexPath?)?.row ?? -1
            self.momentDataSource.append(MomentData())
            self.momentTableView.insertRows(at: [IndexPath(row: lastVisibleRow + 1, section: 0)], with: .fade)
            lastVisibleRow = (self.momentTableView.indexPathsForVisibleRows?.last as NSIndexPath?)?.row ?? -1
            if self.momentDataSource.count > lastVisibleRow + 1 {
                self.momentDataSource.removeLast()
                self.momentTableView.deleteRows(at: [IndexPath(row: lastVisibleRow + 1, section: 0)], with: .none)
                print("一屏已经显示不下啦！")
            }
        }
        view.addSubview(action2)
        
        action3.addTarget(.touchUpInside) { [unowned self] in
            UIImageWriteToSavedPhotosAlbum(UIUtils.imageWithView(self.mockRootView), self, #selector(WechatMomentsController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        action3.setTitle("保存截图", for: UIControlState())
        view.addSubview(action3)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "保存成功", message: "截图已保存至系统相册", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    fileprivate func prepareTableView() {
        momentDataSource = [MomentData]()
        for _ in 0..<1 {
            momentDataSource.append(MomentData())
        }
        
        momentTableView = UITableView()
        momentTableView.register(MomentView.self, forCellReuseIdentifier: "MomentViewCell")
        momentTableView.dataSource = self
        momentTableView.delegate = self
        momentTableView.isScrollEnabled = false
        momentTableView.tableFooterView = UIView()
        momentTableView.separatorStyle = .none
        momentTableView.allowsSelection = false
    }
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }

    fileprivate func prepareView() {
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(mockRootView)
        mockRootView.addSubview(statusBarView)
        mockRootView.addSubview(navigationBarView)
        
        mockRootView.addSubview(coverImage)
        coverImage.kf.setImage(with: URL(string: "http://www.tcsports.com.cn/uploads/allimg/150419/001F0L20-0.jpg")!)
        mockRootView.addSubview(avatarImageBg)
        avatarImage.kf.setImage(with: URL(string: "http://p3.img.cctvpic.com/20130502/images/1367465384571_1367465384571_r.jpg"))
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
        view.backgroundColor = UIColor.white
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
        imageView.tag = ViewID.coverImage.rawValue
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let avatarImageBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.gray.cgColor;
        view.layer.borderWidth = 0.5;
        return view
    }()
    
    let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.avatarImage.rawValue
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    
    let selfNameLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.selfNameLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xfffffdf1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = NSLocalizedString("詹姆斯", comment: "")
        label.shadowColor = UIColor.black;
        label.shadowOffset = CGSize(width: 0, height: 1);
        return label
    }()

    func requestEdit(_ recognizer: UIGestureRecognizer) {
        guard let id = ViewID(rawValue: recognizer.view!.tag) else {
            return
        }
        
        if editMode {
            switch id {
            case .selfNameLabel, .coverImage, .avatarImage:
                let alert = UIAlertController(title: "封面", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "隐藏封面", style: .default) { (action) -> Void in
                    self.toggleCoverVisiblity()
                })
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        case let view where view is UILabel && view!.tag != 0:
            let alert = UIAlertController(title: "编辑文字", message: ViewID(rawValue: view!.tag)?.description, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "请输入文字"
                textField.text = (view as! UILabel).text
            })
            
            alert.addAction(UIAlertAction(title: "确认", style: .default) { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if !(textField.text?.isEmpty ?? true) {
                    (view as! UILabel).text = textField.text
                    
                    switch id {
                    default:
                        break
                    }
                }
            })
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }

    func toggleCoverVisiblity() {
        let hidden = coverImage.isHidden
        selfNameLabel.isHidden = !hidden
        coverImage.isHidden = !hidden
        avatarImage.isHidden = !hidden
        avatarImageBg.isHidden = !hidden
        
        didSetupConstraints = false
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            action1.snp.makeConstraints { make in
                make.leading.equalTo(view).offset(8)
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(8)
                make.width.equalTo(menuItemWidth)
                make.height.equalTo(menuItemHeight)
            }
            
            action2.snp.makeConstraints { make in
                make.leading.equalTo(action1.snp.trailing).offset(8)
                make.top.equalTo(action1)
                make.width.equalTo(menuItemWidth)
                make.height.equalTo(menuItemHeight)
            }

            action3.snp.makeConstraints { make in
                make.leading.equalTo(action2.snp.trailing).offset(8)
                make.top.equalTo(action1)
                make.width.equalTo(menuItemWidth)
                make.height.equalTo(menuItemHeight)
            }
            
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(action1.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalTo(view)
            }
            
            mockRootView.snp.makeConstraints { make in
                make.top.equalTo(scrollView)
                make.centerX.equalTo(scrollView)
                make.bottom.equalTo(scrollView)
                make.width.equalTo(375)
                make.height.equalTo(667)
            }
            
            statusBarView.snp.makeConstraints { make in
                make.top.equalTo(mockRootView)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
                make.height.equalTo(20)
            }
            
            navigationBarView.snp.makeConstraints { make in
                make.top.equalTo(statusBarView.snp.bottom)
                make.leading.equalTo(mockRootView)
                make.trailing.equalTo(mockRootView)
                make.height.equalTo(43)
            }
            
            if !coverImage.isHidden {
                coverImage.snp.removeConstraints()
                avatarImageBg.snp.removeConstraints()
                avatarImage.snp.removeConstraints()
                selfNameLabel.snp.removeConstraints()
                momentTableView.snp.removeConstraints()

                coverImage.snp.makeConstraints { make in
                    make.top.equalTo(navigationBarView.snp.bottom)
                    make.leading.equalTo(mockRootView)
                    make.trailing.equalTo(mockRootView)
                    make.height.equalTo(256)
                }
                
                avatarImageBg.snp.makeConstraints { make in
                    make.bottom.equalTo(coverImage.snp.bottom).inset(-24)
                    make.trailing.equalTo(mockRootView).inset(12)
                    make.width.equalTo(74)
                    make.height.equalTo(74)
                }
                
                avatarImage.snp.makeConstraints { make in
                    make.center.equalTo(avatarImageBg)
                    make.width.equalTo(70)
                    make.height.equalTo(70)
                }
                
                selfNameLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(coverImage.snp.bottom).inset(11)
                    make.right.equalTo(avatarImageBg.snp.left).inset(-22)
                }
                
                momentTableView.snp.makeConstraints { make in
                    make.top.equalTo(coverImage.snp.bottom).offset(52)
                    make.leading.equalTo(mockRootView)
                    make.trailing.equalTo(mockRootView)
                    make.bottom.equalTo(mockRootView)
                }
            } else {
                coverImage.snp.removeConstraints()
                avatarImageBg.snp.removeConstraints()
                avatarImage.snp.removeConstraints()
                selfNameLabel.snp.removeConstraints()
                momentTableView.snp.removeConstraints()
                
                momentTableView.snp.makeConstraints { make in
                    make.top.equalTo(navigationBarView.snp.bottom)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        self.dismiss(animated: true, completion: nil)
        if currentImageView == nil {
            return
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentImageView!.image = image
        }
    }
}

extension WechatMomentsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentDataSource.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MomentView = MomentView(style: .default, reuseIdentifier: "MomentViewCell")
        cell.editMode = editMode
        cell.data = momentDataSource[(indexPath as NSIndexPath).row]
        cell.delegate = self
        return cell
    }
}

extension WechatMomentsController: MomentViewDelegate {
    func removeSelf(_ cell: UITableViewCell) {
        guard let indexPath = self.momentTableView.indexPath(for: cell) else {
            return
        }
        self.momentDataSource.remove(at: (indexPath as NSIndexPath).row)
        self.momentTableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension WechatMomentsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
