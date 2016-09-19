//
//  LikeAndCommentsView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/14/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

class LikeAndCommentsView: UIView {
    
    private var commentTableView: UITableView!
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
        textView.contentInset = UIEdgeInsetsMake(-3, 2, 4, 0)
        textView.editable = false
        textView.scrollEnabled = false
        let linkAttributes = [NSForegroundColorAttributeName: UIUtils.UIColorFromARGB(0xff586C94)]
        textView.linkTextAttributes = linkAttributes
        textView.font = UIFont.systemFontOfSize(12)
        return textView
    }()
    
    var likeDataSource: Array<Like> = [] {
        didSet {
            let attachment = LikeAndCommentsView.textAttachment(14, image: UIImage(named: "Like")!)
            let attachmentString = NSAttributedString(attachment:attachment)
            let attributedString = NSMutableAttributedString(attributedString: attachmentString)
            attributedString.appendAttributedString(generateLikes(likeDataSource))
            likes.attributedText = attributedString
            self.updateConstraints()
        }
    }
    
    var commentDataSource: Array<Comment> = [] {
        didSet {
            commentTableView.reloadData()
            self.updateConstraints()
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
            let attributes = [NSLinkAttributeName: "username://" + String(i), NSFontAttributeName: UIFont.boldSystemFontOfSize(14)]
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
        self.addSubview(triangleIndicator)
        likes.delegate = self
        self.addSubview(likes)
        self.addSubview(separator)
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
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
                make.height.equalTo(newSize.height - 8)
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
}

extension LikeAndCommentsView: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if URL.scheme == "username" {
            return false
        }
        return true
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
        cell.data = commentDataSource[indexPath.row]
        for view in cell.subviews where view.tag != 0 {
            view.addSingleTapGesture(true, closure: gestureClosure)
        }
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
    
    internal var userName: String = defaultUserName
    internal var commentText: String = defaultCommentText
    
    convenience init() {
        self.init(Comment.defaultUserName, Comment.defaultCommentText)
    }
    
    init(_ userName: String, _ commentText: String) {
        self.userName = userName
        self.commentText = commentText
    }
}

class CommentCell: UITableViewCell {
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(commentLabel)
        self.backgroundColor = UIUtils.UIColorFromARGB(0xFFF3F3F5)
        self.updateConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    internal var data = Comment() {
        didSet {
            self.commentLabel.text = data.userName + ": " + data.commentText
        }
    }
    
    override func updateConstraints() {
        commentLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(self).inset(6)
            make.top.equalTo(self).inset(4)
            make.bottom.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        super.updateConstraints()
    }
}