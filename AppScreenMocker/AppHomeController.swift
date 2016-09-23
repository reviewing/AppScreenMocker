//
//  AppBottomNavigationController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/12/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

class AppHomeController: UIViewController {
    
    fileprivate var dataSourceItems: Array<Dictionary<String, AnyObject>>!
    
    fileprivate var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    
    fileprivate func prepareView() {
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.title = "截屏制作"
    }
    
    fileprivate func prepareItems() {
        dataSourceItems = [
            [
                "title": "微信" as AnyObject,
                "detail": "支持朋友圈" as AnyObject,
                "icon": "Wechat" as AnyObject,
                "goto": "WechatScreenList" as AnyObject
            ]
        ]
    }
    
    fileprivate func prepareTableView() {
        tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
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

extension AppHomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = HomeTableViewCell(style: .subtitle, reuseIdentifier: "HomeTableViewCell")
        
        let item = dataSourceItems[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item["title"] as? String
        cell.detailTextLabel?.text = item["detail"] as? String
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = UIImage(named: item["icon"] as! String)
        
        return cell
    }
}

extension AppHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		navigationController?.pushViewController(WechatScreenListController(), animated: true)
    }
}
