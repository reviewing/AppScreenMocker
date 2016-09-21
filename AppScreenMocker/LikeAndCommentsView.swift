//
//  LikeAndCommentsView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/14/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

protocol LikeAndCommentsViewDelegate {
    func removeLikeAtIndex(index: Int)
    func removeCommentAtIndex(index: Int)
}

class LikeAndCommentsView: UIView {
    
    private var commentTableView: UITableView!
    var delegate: LikeAndCommentsViewDelegate?
    internal var editMode: Bool = false
    
    let triangleIndicator: UIView = {
        let view = UIView()
        let triangle = UIBezierPath();
        triangle.moveToPoint(CGPointMake(6, 0))
        triangle.addLineToPoint(CGPointMake(0, 5))
        triangle.addLineToPoint(CGPointMake(12, 5))
        triangle.addLineToPoint(CGPointMake(6, 0))
        triangle.closePath()
        let mask = CAShapeLayer()
        mask.path = triangle.CGPath
        view.layer.mask = mask
        view.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        return view
    }()
    
    let likes: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        textView.contentInset = UIEdgeInsetsMake(4, 2, 4, 0)
        textView.textContainerInset = UIEdgeInsetsZero
        textView.editable = false
        textView.scrollEnabled = false
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
        attributedString.appendAttributedString(attachmentString)
        attributedString.appendAttributedString(NSAttributedString(string: "  "))
        attributedString.appendAttributedString(generateLikes(likeDataSource))
        likes.attributedText = attributedString
    }
    
    var commentDataSource: Array<Comment> = [] {
        didSet {
            commentTableView.reloadData()
        }
    }
    
    static func textAttachment(fontSize: CGFloat, image: UIImage) -> NSTextAttachment {
        let font = UIFont.systemFontOfSize(fontSize)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRectIntegral(CGRect(x: 0, y: font.descender - image.size.height / 2 + mid + 3, width: image.size.width - 1, height: image.size.height - 2))
        return textAttachment
    }
    
    func generateLikes(likes: Array<Like>) -> NSAttributedString {
        let resultString = NSMutableAttributedString()
        for i in 0..<likes.count {
            let like = likes[i]
            let attributes = [NSLinkAttributeName: "internal://like?index=" + String(i), NSFontAttributeName: UIFont.boldSystemFontOfSize(14)]
            let likeString = NSAttributedString(string: like.userName, attributes: attributes)
            resultString.appendAttributedString(likeString)
            resultString.appendAttributedString(NSAttributedString(string: "，", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
        }
        if resultString.length >= 1 {
            resultString.deleteCharactersInRange(NSMakeRange(resultString.length - 1, 1))
        }
        return resultString
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xffe7e7e6)
        return view
    }()
    
    let commentBottomMargin: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
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
        self.addSubview(commentBottomMargin)
        self.updateConstraints()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func prepareTableView() {
        commentTableView = UITableView()
        commentTableView.registerClass(CommentCell.self, forCellReuseIdentifier: "Comment")
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.scrollEnabled = false
        commentTableView.tableFooterView = UIView()
        commentTableView.separatorStyle = .None
        commentTableView.allowsSelection = false
    }
    
    func requestEdit(recognizer: UIGestureRecognizer) {
        if let textView = (recognizer.view as? UITextView) {
            if let indexPath = findIndexPathOfView(textView) {
                self.requestCommentEdit(textView, indexPath: indexPath, elementTag: "body")
            }
        }
    }
    
    override func updateConstraints() {
        
        triangleIndicator.snp_remakeConstraints { (make) in
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
        
        let fixedWidth = CGFloat(375 - 20 - 42 - 10)
        
        likes.snp_remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(triangleIndicator.snp_bottom)
            make.width.equalTo(fixedWidth)
            
            if likeDataSource.count > 0 {
                let newSize = likes.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                make.height.equalTo(newSize.height + 8)
            } else {
                make.height.equalTo(0)
            }
        }
        
        separator.snp_remakeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(likes.snp_bottom)
            
            if likeDataSource.count > 0 && commentDataSource.count > 0 {
                make.height.equalTo(1)
            } else {
                make.height.equalTo(0)
            }
        }
        
        commentTableView.snp_remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(separator.snp_bottom)
            make.trailing.equalTo(self)
            
            if commentDataSource.count > 0 {
                make.height.equalTo(preferredContentSize.height)
            } else {
                make.height.equalTo(0)
            }
        }
        
        commentBottomMargin.snp_remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(commentTableView.snp_bottom)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            
            if commentDataSource.count > 0 {
                make.height.equalTo(4)
            } else {
                make.height.equalTo(0)
            }
        }
        
        super.updateConstraints()
    }
    
    func requestViewLayout() {
        guard let superview = (self.superview as? MomentView) else {
            return
        }
        
        superview.requestCellUpdate()
    }
    
    func requestLikeEdit(textView: UITextView, index: Int) {
        if editMode {
            let alert = UIAlertController(title: likeDataSource[index].userName, message: nil, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "移除赞", style: .Default) { (action) -> Void in
                self.delegate?.removeLikeAtIndex(index)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "编辑文字", message: likeDataSource[index].userName, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "请输入文字"
            textField.text = self.likeDataSource[index].userName
        })
        
        alert.addAction(UIAlertAction(title: "确认", style: .Default) { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if !(textField.text?.isEmpty ?? true) {
                self.likeDataSource[index].userName = textField.text!
                self.requestViewLayout();
            }
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func requestCommentEdit(textView: UITextView, indexPath: NSIndexPath, elementTag: String) {
        if editMode {
            let alert = UIAlertController(title: textView.text, message: nil, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "移除评论", style: .Default) { (action) -> Void in
                self.delegate?.removeCommentAtIndex(indexPath.row)
                })
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var orignialText = ""
        switch elementTag {
        case "from":
            orignialText = commentDataSource[indexPath.row].fromUserName
        case "to":
            orignialText = commentDataSource[indexPath.row].toUserName!
        case "body":
            orignialText = commentDataSource[indexPath.row].commentText
        default:
            break
        }
        let alert = UIAlertController(title: "编辑文字", message: orignialText, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "请输入文字"
            textField.text = orignialText
        })
        
        alert.addAction(UIAlertAction(title: "确认", style: .Default) { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if !(textField.text?.isEmpty ?? true) {
                switch elementTag {
                case "from":
                    self.commentDataSource[indexPath.row].fromUserName = textField.text!
                case "to":
                    self.commentDataSource[indexPath.row].toUserName = textField.text!
                case "body":
                    self.commentDataSource[indexPath.row].commentText = textField.text!
                default:
                    break
                }
                self.requestViewLayout();
            }
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        UIUtils.rootViewController()?.presentViewController(alert, animated: true, completion: nil)
    }
}

extension LikeAndCommentsView: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
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
    
    func findIndexPathOfView(view: UIView?) -> NSIndexPath? {
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
        let indexPath = self.commentTableView.indexPathForCell(commentCell)
        return indexPath
    }
}

extension LikeAndCommentsView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CommentCell = CommentCell(style: .Default, reuseIdentifier: "Comment")
        cell.commentText.delegate = self
        cell.data = commentDataSource[indexPath.row]
        cell.commentText.addSingleTapGesture(true, closure: gestureClosure)
        return cell
    }
}

extension LikeAndCommentsView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            let attributes = [NSLinkAttributeName: "internal://comment?user=from", NSFontAttributeName: UIFont.boldSystemFontOfSize(14)]
            let fromString = NSAttributedString(string: fromUserName, attributes: attributes)
            resultString.appendAttributedString(fromString)
            
            if let to = toUserName {
                resultString.appendAttributedString(NSAttributedString(string: "回复", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)]))
                let attributes = [NSLinkAttributeName: "internal://comment?user=to", NSFontAttributeName: UIFont.boldSystemFontOfSize(14)]
                let toString = NSAttributedString(string: to, attributes: attributes)
                resultString.appendAttributedString(toString)
            }
            
            resultString.appendAttributedString(NSAttributedString(string: ": ", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
            
            resultString.appendAttributedString(NSAttributedString(string: commentText, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)]))
            return resultString
        }
        set {}
    }
    
}

class CommentCell: UITableViewCell {
    let commentText: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 0)
        textView.textContainerInset = UIEdgeInsetsZero
        textView.editable = false
        textView.scrollEnabled = false
        let linkAttributes = [NSForegroundColorAttributeName: UIUtils.UIColorFromARGB(0xff586C94)]
        textView.linkTextAttributes = linkAttributes
        textView.font = UIFont.systemFontOfSize(14)
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
        
        let fixedWidth = CGFloat(375 - 20 - 42 - 10)
        commentText.snp_remakeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(self).offset(5)
            make.width.equalTo(fixedWidth)
            let newSize = commentText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            make.height.equalTo(newSize.height).priorityHigh()
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
}