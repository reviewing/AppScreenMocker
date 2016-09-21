//
//  MomentView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/17/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material
import SnapKit
import Toast_Swift

protocol MomentViewDelegate {
    func removeSelf(cell: UITableViewCell)
}

class MomentView: UITableViewCell {
    var currentImageView: UIImageView?
    var delegate: MomentViewDelegate?

    let hostAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.HostAvatar.rawValue
        imageView.backgroundColor = MaterialColor.black
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let hostName: UILabel = {
        let label = UILabel()
        label.tag = ViewID.HostName.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff465783)
        label.font = UIFont.boldSystemFontOfSize(15)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.BodyLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff222222)
        label.font = UIFont.systemFontOfSize(15)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let singlePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.BodyPhoto.rawValue
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = MaterialColor.black
        return imageView
    }()
    
    let multiplePhotos: SudokuView = {
        let sudokuView = SudokuView()
        sudokuView.tag = ViewID.BodyPhoto.rawValue
        return sudokuView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.LocationLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff5b6a92)
        label.font = UIFont.systemFontOfSize(12)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.TimeLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.SourceLabel.rawValue
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    let actionButton: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.MomentAction.rawValue
        imageView.image = UIImage.init(named: "WechatMomentsAction")
        return imageView
    }()
    
    let likeAndCommentsView: LikeAndCommentsView = {
        let view = LikeAndCommentsView()
        return view
    }()
    
    let bottomMargin: UIView = {
        let view = UIView()
        view.backgroundColor = MaterialColor.white
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xffe7e7e6)
        return view
    }()
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
        
        self.addSubview(hostAvatar)
        self.addSubview(hostName)
        self.addSubview(bodyLabel)
        self.addSubview(singlePhoto)
        self.addSubview(multiplePhotos)
        self.addSubview(locationLabel)
        self.addSubview(timeLabel)
        self.addSubview(sourceLabel)
        self.addSubview(actionButton)
        self.addSubview(likeAndCommentsView)
        self.addSubview(bottomMargin)
        self.addSubview(separator)
        
        hostAvatar.addSingleTapGesture(closure: gestureClosure)
        hostName.addSingleTapGesture(closure: gestureClosure)
        bodyLabel.addSingleTapGesture(closure: gestureClosure)
        singlePhoto.addSingleTapGesture(closure: gestureClosure)
        multiplePhotos.addSingleTapGesture(true, closure: gestureClosure)
        locationLabel.addSingleTapGesture(closure: gestureClosure)
        timeLabel.addSingleTapGesture(closure: gestureClosure)
        sourceLabel.addSingleTapGesture(closure: gestureClosure)
        actionButton.addSingleTapGesture(closure: gestureClosure)

        self.updateConstraints()
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func requestEdit(recognizer: UIGestureRecognizer) {
        guard let id = ViewID(rawValue: recognizer.view!.tag) else {
            return
        }
        
        if editMode {
            switch id {
            case .LocationLabel, .SourceLabel, .BodyPhoto:
                let alert = UIAlertController(title: id.description, message: nil, preferredStyle: .ActionSheet)
                alert.addAction(UIAlertAction(title: "移除" + id.description, style: .Default) { (action) -> Void in
                    let indexPath = self.findTableView()?.indexPathForCell(self)
                    if indexPath == nil {
                        return
                    }
                    
                    switch id {
                    case .LocationLabel:
                        self.data.locationText = nil
                    case .SourceLabel:
                        self.data.sourceText = nil
                    case .BodyPhoto:
                        let index = self.findIndexOfImageView(recognizer.view as? UIImageView, indexPath: indexPath)
                        if index >= 0 {
                            self.data.photoUrls.removeAtIndex(index)
                        }
                    default:
                        break
                    }
                    
                    self.findTableView()?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                    })
                alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
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
            
            UIUtils.rootViewController()?.presentViewController(imagePicker, animated: true, completion: nil)
        case let view where view is UILabel && view!.tag != 0:
            let alert = UIAlertController(title: "编辑文字", message: ViewID(rawValue: view!.tag)?.description, preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "请输入文字"
                textField.text = (view as! UILabel).text
            })
            
            alert.addAction(UIAlertAction(title: "确认", style: .Default) { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                if !(textField.text?.isEmpty ?? true) {
                    (view as! UILabel).text = textField.text
                    
                    switch id {
                    case .HostName:
                        self.data.hostName = textField.text
                    case .BodyLabel:
                        self.data.bodyText = textField.text
                    case .LocationLabel:
                        self.data.locationText = textField.text
                    case .TimeLabel:
                        self.data.timeText = textField.text
                    case .SourceLabel:
                        self.data.sourceText = textField.text
                    default:
                        break
                    }
                }
                })
            
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
        case _ where id == .MomentAction:
            guard let indexPath = findTableView()?.indexPathForCell(self) else {
                return
            }
            let alert = UIAlertController(title: "编辑消息", message: nil, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "添加图片", style: .Default) { (action) -> Void in
                self.data.singlePhotoSize = MomentData.defaultSinglePhotoSize
                if self.data.photoUrls.count < 9 {
                    self.data.photoUrls.append(NSURL())
                    self.findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                } else {
                    self.makeToast("最多只能添加9张图片", duration: 1.0, position: .Bottom)
                }
                })
            alert.addAction(UIAlertAction(title: "显示地点", style: .Default) { (action) -> Void in
                self.data.locationText = MomentData.defaultLocationText
                self.findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "显示来源", style: .Default) { (action) -> Void in
                self.data.sourceText = MomentData.defaultSourceText
                self.findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "添加赞", style: .Default) { (action) -> Void in
                self.data.likes.append(Like("詹姆斯"))
                self.data.likes.append(Like("韦德"))
                self.data.likes.append(Like("奥尼尔"))
                self.findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "添加评论", style: .Default) { (action) -> Void in
                self.data.comments.append(Comment("詹姆斯", "你说得对"))
                self.data.comments.append(Comment(fromUserName: "韦德", toUserName: "詹姆斯", commentText: "信不信我打死你？你看看你说的哪句话是真的？"))
                self.data.comments.append(Comment("奥尼尔", "再给我发一条朋友圈我们还是朋友"))
                self.findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            alert.addAction(UIAlertAction(title: "移除该条朋友圈", style: .Destructive) { (action) -> Void in
                self.delegate?.removeSelf(self)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func findIndexOfImageView(imageView: UIImageView?, indexPath: NSIndexPath?) -> Int {
        if imageView == nil || indexPath == nil {
            return -1;
        }
        if imageView === self.singlePhoto {
            return 0;
        }
        return self.multiplePhotos.imageViews.indexOf(imageView!) ?? -1
    }
    
    internal var editMode = false {
        didSet {
            likeAndCommentsView.editMode = editMode
        }
    }

    internal var data = MomentData() {
        didSet {
            if data.hostAvatarUrl != nil {
                let originalUrl = data.hostAvatarUrl
                UIUtils.imageFromAssetURL(data.hostAvatarUrl!, targetSize: CGSizeMake(40, 40), onComplete: { (image) in
                    if self.data.hostAvatarUrl == originalUrl {
                        self.hostAvatar.image = image
                    }
                })
            } else {
                hostAvatar.image = nil
            }
            hostName.text = data.hostName
            bodyLabel.text = data.bodyText
            if data.photoUrls.count == 1 && data.singlePhotoSize != nil {
                let originalUrl = data.photoUrls[0]
                UIUtils.imageFromAssetURL(originalUrl, targetSize: data.singlePhotoSize!, onComplete: { (image) in
                    if self.data.photoUrls.count == 1 && self.data.photoUrls[0] == originalUrl {
                        self.singlePhoto.image = image
                        self.updateConstraints()
                    }
                })
            } else {
                singlePhoto.image = nil
            }
            singlePhoto.hidden = data.photoUrls.count != 1 || data.singlePhotoSize == nil
            multiplePhotos.hidden = data.photoUrls.count <= 1
            if !multiplePhotos.hidden {
                multiplePhotos.imageUrls = data.photoUrls
            }
            locationLabel.text = data.locationText
            locationLabel.hidden = data.locationText == nil
            timeLabel.text = data.timeText
            sourceLabel.text = data.sourceText
            sourceLabel.hidden = data.sourceText == nil
            likeAndCommentsView.likeDataSource = data.likes
            likeAndCommentsView.commentDataSource = data.comments
            likeAndCommentsView.delegate = self
            
            self.updateConstraints()
        }
    }
    
    func requestCellUpdate() {
        guard let tableView = findTableView() else {
            return
        }
        
        guard let indexPath = tableView.indexPathForCell(self) else {
            return
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    func findTableView() -> UITableView? {
        var view = self.superview;
        
        while (view != nil && !view!.isKindOfClass(UITableView.self)) {
            view = view?.superview;
        }
        
        return view as? UITableView;
    }
    
    override func updateConstraints() {
        hostAvatar.snp_makeConstraints { make in
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self).offset(14)
            make.width.height.equalTo(42)
        }
        
        hostName.snp_makeConstraints { make in
            make.leading.equalTo(hostAvatar.snp_trailing).offset(10)
            make.top.equalTo(hostAvatar)
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
            make.height.equalTo(20)
        }
        
        bodyLabel.snp_makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(hostName.snp_bottom).offset(6).priorityHigh()
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        if !singlePhoto.hidden {
            singlePhoto.snp_removeConstraints()
            multiplePhotos.snp_removeConstraints()
            locationLabel.snp_removeConstraints()
            timeLabel.snp_removeConstraints()

            singlePhoto.snp_makeConstraints { make in
                make.leading.equalTo(hostName)
                make.top.equalTo(bodyLabel.snp_bottom).offset(10)
                if data.singlePhotoSize != nil {
                    make.size.equalTo(data.singlePhotoSize!)
                }
            }
            
            if !locationLabel.hidden {
                locationLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp_bottom).offset(8)
                    make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
                }
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp_bottom).offset(6)
                }
            } else {
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp_bottom).offset(8)
                }
            }
        } else if !multiplePhotos.hidden {
            singlePhoto.snp_removeConstraints()
            multiplePhotos.snp_removeConstraints()
            locationLabel.snp_removeConstraints()
            timeLabel.snp_removeConstraints()
            
            multiplePhotos.updateConstraints()
            multiplePhotos.snp_makeConstraints { make in
                make.leading.equalTo(hostName)
                make.top.equalTo(bodyLabel.snp_bottom).offset(10)
            }
            
            if !locationLabel.hidden {
                locationLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(multiplePhotos.snp_bottom).offset(8)
                    make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
                }
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp_bottom).offset(6)
                }
            } else {
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(multiplePhotos.snp_bottom).offset(8)
                }
            }
        } else {
            singlePhoto.snp_removeConstraints()
            multiplePhotos.snp_removeConstraints()
            locationLabel.snp_removeConstraints()
            timeLabel.snp_removeConstraints()
            if !locationLabel.hidden {
                locationLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp_bottom).offset(8)
                    make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
                }
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp_bottom).offset(6)
                }
            } else {
                timeLabel.snp_makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp_bottom).offset(8)
                }
            }
        }
        
        sourceLabel.snp_makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp_trailing).offset(8)
        }
        
        actionButton.snp_makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.trailing.equalTo(self.snp_trailing).inset(10).priorityHigh()
        }
        
        likeAndCommentsView.updateConstraints()
        
        likeAndCommentsView.snp_makeConstraints { (make) in
            make.leading.equalTo(timeLabel.snp_leading)
            make.top.equalTo(timeLabel.snp_bottom)
            make.trailing.equalTo(self.snp_trailing).inset(10)
        }
        
        bottomMargin.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(16)
            make.top.equalTo(likeAndCommentsView.snp_bottom)
            make.bottom.equalTo(self)
        }
        
        separator.snp_makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    static func computeImageSize(instinct: CGSize?) -> CGSize {
        if instinct == nil {
            return CGSizeZero
        }
        return computeImageSize(CGSize(width: 120, height: 120), max: CGSize(width: 180, height: 180), instinct: instinct!)
    }
    
    static func computeImageSize(min: CGSize, max: CGSize, instinct: CGSize) -> CGSize {
        let aspectRatio = instinct.width / instinct.height
        var width: CGFloat = min.width
        var height: CGFloat = min.height
        if instinct.width <= min.width {
            width = min.width
            height = width / aspectRatio
        }
        
        if height <= min.height {
            width = width / (height / min.height)
            height = min.height
            width = clamp(min.width, max: max.width, instinct: width)
        }
        
        if instinct.width >= max.width {
            width = max.width
            height = width / aspectRatio
        }
        
        if height >= max.height {
            width = width / (height / max.height)
            height = max.height
            width = clamp(min.width, max: max.width, instinct: width)
        }
        
        return CGSizeMake(width, height)
    }
    
    static func clamp(min: CGFloat, max: CGFloat, instinct: CGFloat) -> CGFloat {
        if instinct < min {
            return min
        }
        if instinct > max {
            return max
        }
        return instinct
    }
}

extension MomentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        UIUtils.rootViewController()?.dismissViewControllerAnimated(true, completion: nil)
        if currentImageView == nil {
            return
        }
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        guard let indexPath = findTableView()?.indexPathForCell(self) else {
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
            self.data.hostAvatarUrl = imageUrl
        case .BodyPhoto:
            let index = self.findIndexOfImageView(currentImageView, indexPath: indexPath)
            if index >= 0 {
                self.data.photoUrls[index] = imageUrl
                if self.data.photoUrls.count == 1 {
                    self.data.singlePhotoSize = MomentView.computeImageSize(image?.size)
                }
            }
        default:
            break
        }
        findTableView()?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

extension MomentView: LikeAndCommentsViewDelegate {
    func removeLikeAtIndex(index: Int) {
        self.data.likes.removeAtIndex(index)
        self.requestCellUpdate()
    }
    
    func removeCommentAtIndex(index: Int) {
        self.data.comments.removeAtIndex(index)
        self.requestCellUpdate()
    }
}