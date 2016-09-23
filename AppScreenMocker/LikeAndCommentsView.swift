//
//  LikeAndCommentsView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/14/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

protocol LikeAndCommentsViewDelegate {
    func removeLikeAtIndex(_ index: Int)
    func removeCommentAtIndex(_ index: Int)
}

class LikeAndCommentsView: UIView {
    var viewOptions = ViewOptions.defaultOptions
    
    fileprivate var commentTableView: UITableView!
    var delegate: LikeAndCommentsViewDelegate?
    internal var isEditing = false {
        didSet {
            commentTableView.setEditing(isEditing, animated: true)
        }
    }
    
    let triangleIndicator: UIView = {
        let view = UIView()
        let triangle = UIBezierPath();
        triangle.move(to: CGPoint(x: 6, y: 0))
        triangle.addLine(to: CGPoint(x: 0, y: 5))
        triangle.addLine(to: CGPoint(x: 12, y: 5))
        triangle.addLine(to: CGPoint(x: 6, y: 0))
        triangle.close()
        let mask = CAShapeLayer()
        mask.path = triangle.cgPath
        view.layer.mask = mask
        view.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        return view
    }()
    
    let likes: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        textView.contentInset = UIEdgeInsetsMake(4, 2, 4, 0)
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isEditable = false
        textView.isScrollEnabled = false
        let linkAttributes = [NSForegroundColorAttributeName: UIUtils.UIColorFromARGB(0xff586C94)]
        textView.linkTextAttributes = linkAttributes
        return textView
    }()
    
    var likeDataSource: Array<Like> = [] {
        didSet {
            refreshLikes()
        }
    }
    
    func refreshLikes() {
        let attachment = LikeAndCommentsView.textAttachment(14, image: UIImage(named: "Like")!)
        let attachmentString = NSAttributedString(attachment:attachment)
        let attributedString = NSMutableAttributedString(string: " ")
        attributedString.append(attachmentString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(generateLikes(likeDataSource))
        likes.attributedText = attributedString
    }
    
    var commentDataSource: Array<Comment> = [] {
        didSet {
            commentTableView.reloadData()
        }
    }
    
    static func textAttachment(_ fontSize: CGFloat, image: UIImage) -> NSTextAttachment {
        let font = UIFont.systemFont(ofSize: fontSize)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRect(x: 0, y: font.descender - image.size.height / 2 + mid + 3, width: image.size.width - 1, height: image.size.height - 2).integral
        return textAttachment
    }
    
    func generateLikes(_ likes: Array<Like>) -> NSAttributedString {
        let resultString = NSMutableAttributedString()
        for i in 0..<likes.count {
            let like = likes[i]
            let attributes = [NSLinkAttributeName: "internal://like?index=" + String(i), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)] as [String : Any]
            let likeString = NSAttributedString(string: like.userName, attributes: attributes)
            resultString.append(likeString)
            resultString.append(NSAttributedString(string: "，", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]))
        }
        if resultString.length >= 1 {
            resultString.deleteCharacters(in: NSMakeRange(resultString.length - 1, 1))
        }
        return resultString
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xffe7e7e6)
        return view
    }()
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }
    
    var preferredContentSize: CGSize {
        get {
            self.commentTableView.layoutIfNeeded()
            return self.commentTableView.contentSize
        }
        set {}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
        
        self.addSubview(triangleIndicator)
        likes.delegate = self
        self.addSubview(likes)
        self.addSubview(separator)
        prepareTableView()
        self.addSubview(commentTableView)
        self.clipsToBounds = true
        self.updateConstraints()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    fileprivate func prepareTableView() {
        commentTableView = UITableView()
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: "Comment")
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.isScrollEnabled = false
        commentTableView.tableFooterView = UIView()
        commentTableView.separatorStyle = .none
        commentTableView.allowsSelection = false
    }
    
    func requestEdit(_ recognizer: UIGestureRecognizer) {
        if let textView = (recognizer.view as? UITextView) {
            if let indexPath = findIndexPathOfView(textView) {
                self.requestCommentEdit(textView, indexPath: indexPath, elementTag: "body")
            }
        }
    }
    
    override func updateConstraints() {
        
        triangleIndicator.snp.remakeConstraints { (make) in
            make.leading.equalTo(self).offset(10)
            make.width.equalTo(12)
            
            if likeDataSource.count <= 0 && commentDataSource.count <= 0 {
                make.top.equalTo(self).offset(0)
                make.height.equalTo(0)
            } else {
                make.top.equalTo(self).offset(8)
                make.height.equalTo(5)
            }
        }
        
        let fixedWidth = CGFloat(viewOptions.screenWidth - 2 * MomentConstants.momentPaddingLeftRight - MomentConstants.momentHostAvatarSize - MomentConstants.momentHostNameMarginLeft)
        
        likes.snp.remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(triangleIndicator.snp.bottom)
            make.width.equalTo(fixedWidth)
            
            if likeDataSource.count > 0 {
                let newSize = likes.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                make.height.equalTo(newSize.height + 8)
            } else {
                make.height.equalTo(0)
            }
        }
        
        separator.snp.remakeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(likes.snp.bottom)
            
            if likeDataSource.count > 0 && commentDataSource.count > 0 {
                make.height.equalTo(1)
            } else {
                make.height.equalTo(0)
            }
        }
        
        commentTableView.snp.remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(separator.snp.bottom)
            make.trailing.equalTo(self)
            
            if commentDataSource.count > 0 {
                let tableHeight = preferredContentSize.height
                commentTableView.snp.updateConstraints{ (make) in
                    make.height.equalTo(tableHeight)
                }
            } else {
                make.height.equalTo(0)
            }
            
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    func requestViewLayout() {
        guard let superview = (self.superview as? MomentView) else {
            return
        }
        
        superview.requestCellUpdate()
    }
    
    func requestLikeEdit(_ textView: UITextView, index: Int) {
        if isEditing {
            let alert = UIAlertController(title: likeDataSource[index].userName, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "移除赞", style: .default) { (action) -> Void in
                self.delegate?.removeLikeAtIndex(index)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "编辑文字", message: likeDataSource[index].userName, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "请输入文字"
            textField.text = self.likeDataSource[index].userName
        })
        
        alert.addAction(UIAlertAction(title: "确认", style: .default) { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if !(textField.text?.isEmpty ?? true) {
                self.likeDataSource[index].userName = textField.text!
                self.requestViewLayout();
            }
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func requestCommentEdit(_ textView: UITextView, indexPath: IndexPath, elementTag: String) {
        if isEditing {
            let alert = UIAlertController(title: textView.text, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "移除评论", style: .default) { (action) -> Void in
                self.delegate?.removeCommentAtIndex((indexPath as NSIndexPath).row)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
            return
        }
        
        var orignialText = ""
        switch elementTag {
        case "from":
            orignialText = commentDataSource[(indexPath as NSIndexPath).row].fromUserName
        case "to":
            orignialText = commentDataSource[(indexPath as NSIndexPath).row].toUserName!
        case "body":
            orignialText = commentDataSource[(indexPath as NSIndexPath).row].commentText
        default:
            break
        }
        let alert = UIAlertController(title: "编辑文字", message: orignialText, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "请输入文字"
            textField.text = orignialText
        })
        
        alert.addAction(UIAlertAction(title: "确认", style: .default) { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if !(textField.text?.isEmpty ?? true) {
                switch elementTag {
                case "from":
                    self.commentDataSource[(indexPath as NSIndexPath).row].fromUserName = textField.text!
                case "to":
                    self.commentDataSource[(indexPath as NSIndexPath).row].toUserName = textField.text!
                case "body":
                    self.commentDataSource[(indexPath as NSIndexPath).row].commentText = textField.text!
                default:
                    break
                }
                self.requestViewLayout();
            }
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        UIUtils.rootViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension LikeAndCommentsView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "internal" {
            let host = URL.host
            let params = URL.queryItems
            if host == "like" {
                if let p = params {
                    if let i = p["index"] {
                        if let index = Int(i) {
                            self.requestLikeEdit(textView, index: index)
                        }
                    }
                }
            } else if host == "comment" {
                if let p = params {
                    if let user = p["user"] {
                        if let indexPath = findIndexPathOfView(textView) {
                            self.requestCommentEdit(textView, indexPath: indexPath, elementTag: user)
                        }
                    }
                }
            }
            
            return false
        }
        return true
    }
    
    func findIndexPathOfView(_ view: UIView?) -> IndexPath? {
        var v: UIView? = view
        while v != nil {
            if v is CommentCell {
                break
            }
            v = v!.superview
        }
        
        if v == nil {
            return nil
        }
        
        let commentCell = v as! CommentCell
        let indexPath = self.commentTableView.indexPath(for: commentCell)
        return indexPath
    }
}

extension LikeAndCommentsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = CommentCell(style: .default, reuseIdentifier: "Comment")
        cell.commentText.delegate = self
        cell.data = commentDataSource[(indexPath as NSIndexPath).row]
        cell.viewOptions = viewOptions
        cell.commentText.addSingleTapGesture(true, closure: gestureClosure)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.delegate?.removeCommentAtIndex((indexPath as NSIndexPath).row)
        }
    }
}

extension LikeAndCommentsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}

class Like {
    static let defaultUserName = "科比"
    internal var userName: String = defaultUserName
    
    init(_ userName: String) {
        self.userName = userName
    }
}

class Comment {
    static let defaultUserName = "詹姆斯"
    static let defaultCommentText = "你说得对"
    
    internal var fromUserName: String = defaultUserName
    internal var toUserName: String?
    internal var commentText: String = defaultCommentText
    
    convenience init() {
        self.init(Comment.defaultUserName, Comment.defaultCommentText)
    }
    
    init(_ fromUserName: String, _ commentText: String) {
        self.fromUserName = fromUserName
        self.commentText = commentText
    }
    
    init(fromUserName: String, toUserName: String, commentText: String) {
        self.fromUserName = fromUserName
        self.toUserName = toUserName
        self.commentText = commentText
    }
    
    var attributedString: NSAttributedString {
        get {
            let resultString = NSMutableAttributedString()
            let attributes = [NSLinkAttributeName: "internal://comment?user=from", NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)] as [String : Any]
            let fromString = NSAttributedString(string: fromUserName, attributes: attributes)
            resultString.append(fromString)
            
            if let to = toUserName {
                resultString.append(NSAttributedString(string: "回复", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
                let attributes = [NSLinkAttributeName: "internal://comment?user=to", NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)] as [String : Any]
                let toString = NSAttributedString(string: to, attributes: attributes)
                resultString.append(toString)
            }
            
            resultString.append(NSAttributedString(string: ": ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]))
            
            resultString.append(NSAttributedString(string: commentText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            return resultString
        }
        set {}
    }
    
}

class CommentCell: UITableViewCell {
    var viewOptions = ViewOptions.defaultOptions

    let commentText: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 0)
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isEditable = false
        textView.isScrollEnabled = false
        let linkAttributes = [NSForegroundColorAttributeName: UIUtils.UIColorFromARGB(0xff586C94)]
        textView.linkTextAttributes = linkAttributes
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(commentText)
        self.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        self.updateConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    internal var data = Comment() {
        didSet {
            self.commentText.attributedText = data.attributedString
            self.updateConstraints()
        }
    }
    
    override func updateConstraints() {
        
        let fixedWidth = CGFloat(viewOptions.screenWidth - 2 * MomentConstants.momentPaddingLeftRight - MomentConstants.momentHostAvatarSize - MomentConstants.momentHostNameMarginLeft)
        commentText.snp.remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(self).offset(5)
            make.width.equalTo(fixedWidth)
            let newSize = commentText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            make.height.equalTo(newSize.height).priority(750)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
}
