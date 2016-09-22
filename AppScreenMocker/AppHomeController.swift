//
//  AppBottomNavigationController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/12/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class AppHomeController: UIViewController {
    
    private var dataSourceItems: Array<Dictionary<String, AnyObject>>!
    
    private var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        prepareView()
        prepareItems()
        prepareTableView()
        updateViewConstraints()
    }
    
    private func prepareView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "截屏构造"
    }
    
    private func prepareItems() {
        dataSourceItems = [
            [
                "title": "微信",
                "detail": "支持朋友圈",
                "icon": "Wechat",
                "goto": "WechatScreenList"
            ]
        ]
    }
    
    private func prepareTableView() {
        tableView = UITableView()
        tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
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

extension AppHomeController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = HomeTableViewCell(style: .Subtitle, reuseIdentifier: "HomeTableViewCell")
        
        let item = dataSourceItems[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel?.text = item["title"] as? String
        cell.detailTextLabel?.text = item["detail"] as? String
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = UIImage(named: item["icon"] as! String)
        
        return cell
    }
}

extension AppHomeController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		navigationController?.pushViewController(WechatScreenListController(), animated: true)
    }
}