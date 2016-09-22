//
//  WechatScreenList.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class WechatScreenListController: UIViewController {
    
    private var dataSourceItems: Array<Dictionary<String, AnyObject>>!
    
    private var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        prepareView()
        prepareItems()
        prepareTableView()
        updateViewConstraints()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "微信"
    }

    private func prepareView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func prepareItems() {
        dataSourceItems = [
            [
                "title": "朋友圈",
                "icon": "WechatMoments",
                "goto": "WechatMoments"
            ]
        ]
    }
    
    private func prepareTableView() {
        tableView = UITableView()
        tableView.registerClass(WechatScreenTableViewCell.self, forCellReuseIdentifier: "WechatScreenTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    override func updateViewConstraints() {
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        super.updateViewConstraints()
    }
}

extension WechatScreenListController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: WechatScreenTableViewCell = WechatScreenTableViewCell(style: .Default, reuseIdentifier: "WechatScreenTableViewCell")
        
        let item = dataSourceItems[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel?.text = item["title"] as? String
        cell.detailTextLabel?.text = item["detail"] as? String
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = UIImage(named: item["icon"] as! String)
        
        return cell
    }
}

extension WechatScreenListController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(WechatMomentsController(), animated: true)
    }
}