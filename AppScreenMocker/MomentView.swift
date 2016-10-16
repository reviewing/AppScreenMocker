//
//  MomentView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/17/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import SnapKit

protocol MomentViewDelegate {
    func removeSelf(_ cell: UITableViewCell)
}

class MomentView: UITableViewCell {
    var viewOptions = ViewOptions.defaultOptions {
        didSet {
            likeAndCommentsView.viewOptions = viewOptions
        }
    }

    var currentImageView: UIImageView?
    var delegate: MomentViewDelegate?

    let hostAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.hostAvatar.rawValue
        imageView.backgroundColor = UIUtils.UIColorFromARGB(0xfff44336)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let hostName: UILabel = {
        let label = UILabel()
        label.tag = ViewID.hostName.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff465783)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.bodyLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff222222)
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let singlePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.bodyPhoto.rawValue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIUtils.UIColorFromARGB(0xfff44336)
        return imageView
    }()
    
    let multiplePhotos: SudokuView = {
        let sudokuView = SudokuView()
        sudokuView.tag = ViewID.bodyPhoto.rawValue
        return sudokuView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.locationLabel.rawValue
        label.textColor = UIUtils.UIColorFromARGB(0xff5b6a92)
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.timeLabel.rawValue
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.tag = ViewID.sourceLabel.rawValue
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let actionButton: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = ViewID.momentAction.rawValue
        imageView.image = UIImage.init(named: "WechatMomentsAction")
        return imageView
    }()
    
    let likeAndCommentsView: LikeAndCommentsView = {
        let view = LikeAndCommentsView()
        return view
    }()
    
    let bottomMargin: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
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
        locationLabel.addSingleTapGesture(closure: gestureClosure)
        timeLabel.addSingleTapGesture(closure: gestureClosure)
        sourceLabel.addSingleTapGesture(closure: gestureClosure)
        actionButton.addSingleTapGesture(closure: gestureClosure)

        self.updateConstraints()
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func setEditing(_ editing:Bool, animated:Bool) {
        super.setEditing(editing, animated:animated)
        likeAndCommentsView.isEditing = editing
    }
    
    func requestEdit(_ recognizer: UIGestureRecognizer) {
        guard let id = ViewID(rawValue: recognizer.view!.tag) else {
            return
        }
        
        if isEditing {
            switch id {
            case .locationLabel, .sourceLabel, .bodyPhoto:
                let alert = UIAlertController(title: id.description, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "移除" + id.description, style: .default) { (action) -> Void in
                    let indexPath = self.findTableView()?.indexPath(for: self)
                    if indexPath == nil {
                        return
                    }
                    
                    switch id {
                    case .locationLabel:
                        self.data.locationText = nil
                    case .sourceLabel:
                        self.data.sourceText = nil
                    case .bodyPhoto:
                        let index = self.findIndexOfImageView(recognizer.view as? UIImageView, indexPath: indexPath)
                        if index >= 0 {
                            self.data.photoUrls.remove(at: index)
                        }
                    default:
                        break
                    }
                    
                    self.findTableView()?.reloadRows(at: [indexPath!], with: .fade)
                    })
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
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
            
            UIUtils.rootViewController()?.present(imagePicker, animated: true, completion: nil)
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
                    case .hostName:
                        self.data.hostName = textField.text
                    case .bodyLabel:
                        self.data.bodyText = textField.text
                    case .locationLabel:
                        self.data.locationText = textField.text
                    case .timeLabel:
                        self.data.timeText = textField.text
                    case .sourceLabel:
                        self.data.sourceText = textField.text
                    default:
                        break
                    }
                }
                })
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
        case _ where id == .momentAction:
            guard let indexPath = findTableView()?.indexPath(for: self) else {
                return
            }
            let alert = UIAlertController(title: "编辑消息", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "添加图片", style: .default) { (action) -> Void in
                self.data.singlePhotoSize = MomentData.defaultSinglePhotoSize
                if self.data.photoUrls.count < 9 {
                    self.data.photoUrls.append(nil)
                    self.findTableView()?.reloadRows(at: [indexPath], with: .fade)
                } else {
                    print("最多只能添加9张图片")
                }
                })
            alert.addAction(UIAlertAction(title: "显示地点", style: .default) { (action) -> Void in
                self.data.locationText = MomentData.defaultLocationText
                self.findTableView()?.reloadRows(at: [indexPath], with: .fade)
                })
            alert.addAction(UIAlertAction(title: "显示来源", style: .default) { (action) -> Void in
                self.data.sourceText = MomentData.defaultSourceText
                self.findTableView()?.reloadRows(at: [indexPath], with: .fade)
                })
            alert.addAction(UIAlertAction(title: "添加赞", style: .default) { (action) -> Void in
                self.data.likes.append(Like("小红"))
                self.data.likes.append(Like("小明"))
                self.data.likes.append(Like("小明的女朋友"))
                self.data.likes.append(Like("小明的基友"))
                self.findTableView()?.reloadRows(at: [indexPath], with: .fade)
                })
            alert.addAction(UIAlertAction(title: "添加评论", style: .default) { (action) -> Void in
                self.data.comments.append(Comment("小明", "你说得对"))
                self.data.comments.append(Comment(fromUserName: "小明的女朋友", toUserName: "小明", commentText: "信不信我打死你？"))
                self.data.comments.append(Comment("小红的基友", "再给我发一条朋友圈我们还是朋友"))
                self.findTableView()?.reloadRows(at: [indexPath], with: .fade)
                })
            alert.addAction(UIAlertAction(title: "移除该条朋友圈", style: .destructive) { (action) -> Void in
                self.delegate?.removeSelf(self)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func findIndexOfImageView(_ imageView: UIImageView?, indexPath: IndexPath?) -> Int {
        if imageView == nil || indexPath == nil {
            return -1;
        }
        if imageView === self.singlePhoto {
            return 0;
        }
        return self.multiplePhotos.imageViews.index(of: imageView!) ?? -1
    }

    internal var data = MomentData() {
        didSet {
            if data.hostAvatarUrl != nil {
                let originalUrl = data.hostAvatarUrl
                UIUtils.imageFromAssetURL(data.hostAvatarUrl!, targetSize: CGSize(width: 40, height: 40), onComplete: { (image) in
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
                if let originalUrl = data.photoUrls[0] {
                    UIUtils.imageFromAssetURL(originalUrl, targetSize: data.singlePhotoSize!, onComplete: { (image) in
                        if self.data.photoUrls.count == 1 && self.data.photoUrls[0] == originalUrl {
                            self.singlePhoto.image = image
                        }
                    })
                }
            } else {
                singlePhoto.image = nil
            }
            singlePhoto.isHidden = data.photoUrls.count != 1 || data.singlePhotoSize == nil
            multiplePhotos.isHidden = data.photoUrls.count <= 1
            if !multiplePhotos.isHidden {
                multiplePhotos.imageUrls = data.photoUrls
                multiplePhotos.addSingleTapGesture(true, closure: gestureClosure)
            }
            locationLabel.text = data.locationText
            locationLabel.isHidden = data.locationText == nil
            timeLabel.text = data.timeText
            sourceLabel.text = data.sourceText
            sourceLabel.isHidden = data.sourceText == nil
            likeAndCommentsView.likeDataSource = data.likes
            likeAndCommentsView.commentDataSource = data.comments
            likeAndCommentsView.delegate = self
        }
    }
    
    func requestCellUpdate() {
        guard let tableView = findTableView() else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: self) else {
            return
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func findTableView() -> UITableView? {
        var view = self.superview;
        
        while (view != nil && !view!.isKind(of: UITableView.self)) {
            view = view?.superview;
        }
        
        return view as? UITableView;
    }
    
    override func updateConstraints() {
        hostAvatar.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(MomentConstants.momentPaddingLeftRight)
            make.top.equalTo(self).offset(14)
            make.width.height.equalTo(MomentConstants.momentHostAvatarSize)
        }
        
        hostName.snp.makeConstraints { make in
            make.leading.equalTo(hostAvatar.snp.trailing).offset(MomentConstants.momentHostNameMarginLeft)
            make.top.equalTo(hostAvatar)
            make.trailing.equalTo(self.snp.trailing).inset(10).priority(750)
            make.height.equalTo(20)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.leading.equalTo(hostName)
            make.top.equalTo(hostName.snp.bottom).offset(6).priority(750)
            make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight).priority(750)
        }
        
        if !singlePhoto.isHidden {
            singlePhoto.snp.removeConstraints()
            multiplePhotos.snp.removeConstraints()
            locationLabel.snp.removeConstraints()
            timeLabel.snp.removeConstraints()

            singlePhoto.snp.makeConstraints { make in
                make.leading.equalTo(hostName)
                make.top.equalTo(bodyLabel.snp.bottom).offset(10)
                if data.singlePhotoSize != nil {
                    make.size.equalTo(data.singlePhotoSize!)
                }
            }
            
            if !locationLabel.isHidden {
                locationLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp.bottom).offset(8)
                    make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight).priority(750)
                }
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp.bottom).offset(6)
                }
            } else {
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(singlePhoto.snp.bottom).offset(8)
                }
            }
        } else if !multiplePhotos.isHidden {
            singlePhoto.snp.removeConstraints()
            multiplePhotos.snp.removeConstraints()
            locationLabel.snp.removeConstraints()
            timeLabel.snp.removeConstraints()
            
            multiplePhotos.updateConstraints()
            multiplePhotos.snp.makeConstraints { make in
                make.leading.equalTo(hostName)
                make.top.equalTo(bodyLabel.snp.bottom).offset(10)
            }
            
            if !locationLabel.isHidden {
                locationLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(multiplePhotos.snp.bottom).offset(8)
                    make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight).priority(750)
                }
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp.bottom).offset(6)
                }
            } else {
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(multiplePhotos.snp.bottom).offset(8)
                }
            }
        } else {
            singlePhoto.snp.removeConstraints()
            multiplePhotos.snp.removeConstraints()
            locationLabel.snp.removeConstraints()
            timeLabel.snp.removeConstraints()
            if !locationLabel.isHidden {
                locationLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp.bottom).offset(8)
                    make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight).priority(750)
                }
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(locationLabel.snp.bottom).offset(6)
                }
            } else {
                timeLabel.snp.makeConstraints { make in
                    make.leading.equalTo(hostName)
                    make.top.equalTo(bodyLabel.snp.bottom).offset(8)
                }
            }
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight).priority(750)
        }
        
        likeAndCommentsView.updateConstraints()
        
        likeAndCommentsView.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel.snp.leading)
            make.top.equalTo(timeLabel.snp.bottom)
            make.trailing.equalTo(self.snp.trailing).inset(MomentConstants.momentPaddingLeftRight)
        }
        
        bottomMargin.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(16)
            make.top.equalTo(likeAndCommentsView.snp.bottom)
            make.bottom.equalTo(self)
        }
        
        separator.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    static let minSizeOfSinglePhoto = 120
    static let maxSizeOfSinglePhoto = 180

    static func computeImageSize(_ instinct: CGSize?) -> CGSize {
        if instinct == nil {
            return CGSize.zero
        }
        return computeImageSize(CGSize(width: minSizeOfSinglePhoto, height: minSizeOfSinglePhoto), max: CGSize(width: maxSizeOfSinglePhoto, height: maxSizeOfSinglePhoto), instinct: instinct!)
    }
    
    static func computeImageSize(_ min: CGSize, max: CGSize, instinct: CGSize) -> CGSize {
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
        
        return CGSize(width: width, height: height)
    }
    
    static func clamp(_ min: CGFloat, max: CGFloat, instinct: CGFloat) -> CGFloat {
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        UIUtils.rootViewController()?.dismiss(animated: true, completion: nil)
        if currentImageView == nil {
            return
        }
        
        
        guard let indexPath = findTableView()?.indexPath(for: self) else {
            return
        }
        
        let id = ViewID(rawValue: currentImageView!.tag);
        
        if id == nil {
            return
        }
        
        guard let imageUrl = info[UIImagePickerControllerReferenceURL] as? URL else {
            return
        }
        
        switch id! {
        case .hostAvatar:
            self.data.hostAvatarUrl = imageUrl
        case .bodyPhoto:
            let index = self.findIndexOfImageView(currentImageView, indexPath: indexPath)
            if index >= 0 {
                self.data.photoUrls[index] = imageUrl
                if self.data.photoUrls.count == 1 {
                    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        self.data.singlePhotoSize = MomentView.computeImageSize(image.size)
                    }
                }
            }
        default:
            break
        }
        findTableView()?.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension MomentView: LikeAndCommentsViewDelegate {
    func removeLikeAtIndex(_ index: Int) {
        self.data.likes.remove(at: index)
        self.requestCellUpdate()
    }
    
    func removeCommentAtIndex(_ index: Int) {
        self.data.comments.remove(at: index)
        self.requestCellUpdate()
    }
}
