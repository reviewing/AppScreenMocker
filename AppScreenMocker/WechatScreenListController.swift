//
//  WechatScreenList.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class WechatScreenListController: UIViewController {
    
    fileprivate var dataSourceItems: Array<Dictionary<String, AnyObject>>!
    
    fileprivate var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "微信"
    }

    fileprivate func prepareView() {
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func prepareItems() {
        dataSourceItems = [
            [
                "title": "朋友圈" as AnyObject,
                "icon": "WechatMoments" as AnyObject,
                "goto": "WechatMoments" as AnyObject
            ]
        ]
    }
    
    fileprivate func prepareTableView() {
        tableView = UITableView()
        tableView.register(WechatScreenTableViewCell.self, forCellReuseIdentifier: "WechatScreenTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        super.updateViewConstraints()
    }
}

extension WechatScreenListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WechatScreenTableViewCell = WechatScreenTableViewCell(style: .default, reuseIdentifier: "WechatScreenTableViewCell")
        
        let item = dataSourceItems[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item["title"] as? String
        cell.detailTextLabel?.text = item["detail"] as? String
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = UIImage(named: item["icon"] as! String)
        
        return cell
    }
}

extension WechatScreenListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(WechatMomentsController(), animated: true)
    }
}
