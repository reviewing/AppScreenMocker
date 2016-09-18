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
    
    private var likeDataSource: Array<Like>!
    private var commentDataSource: Array<Comment>!
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
        textView.textColor = UIUtils.UIColorFromARGB(0xff586C94)
        textView.contentInset = UIEdgeInsetsMake(-3, 2, 4, 0)
        textView.text = "科比，詹姆斯，奥尼尔"
        textView.font = UIFont.boldSystemFontOfSize(14)
        return textView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.UIColorFromARGB(0xffe7e7e6)
        return view
    }()
    
    var gestureClosure: (UIGestureRecognizer) -> () = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(triangleIndicator)
        self.addSubview(likes)
        self.addSubview(separator)
        gestureClosure = {[unowned self] (recognizer: UIGestureRecognizer) in
            self.requestEdit(recognizer)
        }
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
    
    private func prepareTableView() {
        commentDataSource = [Comment]()
        commentDataSource.append(Comment())
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
        triangleIndicator.snp_makeConstraints { (make) in
            make.leading.equalTo(self).offset(10)
            make.top.equalTo(self)
            make.height.equalTo(5)
            make.width.equalTo(12)
        }
        
        let fixedWidth = CGFloat(375 - 20 - 42 - 10)
        
        likes.snp_makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(triangleIndicator.snp_bottom)
            
            var newSize = likes.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            newSize.width = fixedWidth
            newSize.height -= 8
            make.size.equalTo(newSize)
        }
        
        separator.snp_makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(1)
            make.top.equalTo(likes.snp_bottom)
        }
        
        commentTableView.snp_makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(separator.snp_bottom)
            make.height.equalTo(48)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
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
}

class Comment {
    static let defaultUserName = "詹姆斯"
    static let defaultCommentText = "你说得对，每天晚上睡觉前我们都会FaceTime两小时呢，嘿嘿嘿"
    
    internal var userName: String = defaultUserName
    internal var commentText: String = defaultCommentText
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
            self.commentLabel.text = data.userName + "：" + data.commentText
        }
    }
    
    override func updateConstraints() {
        commentLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(self).inset(6)
            make.top.equalTo(self).inset(4)
            make.bottom.equalTo(self).inset(4)
            make.trailing.equalTo(self)
        }
        
        super.updateConstraints()
    }
}