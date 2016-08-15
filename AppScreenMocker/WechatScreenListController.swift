//
//  WechatScreenList.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

class WechatScreenListController: UIViewController {
    
    /// A list of all the data source items.
    private var dataSourceItems: Array<MaterialDataSourceItem>!
    
    /// A tableView used to display items.
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
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBar.backgroundColor = MaterialColor.green.darken1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        prepareView()
        prepareItems()
        prepareTableView()
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "微信"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
    }

    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the items Array.
    private func prepareItems() {
        dataSourceItems = [
            MaterialDataSourceItem(
                data: [
                    "title": "朋友圈",
                    "icon": "WechatMoments",
                    "goto": "WechatMoments"
                ]
            )
        ]
    }
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView = UITableView()
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges()
    }
}

/// TableViewDataSource methods.
extension WechatScreenListController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count;
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Default, reuseIdentifier: "MaterialTableViewCell")
        let item: MaterialDataSourceItem = dataSourceItems[indexPath.row]
        
        if let data: Dictionary<String, AnyObject> =  item.data as? Dictionary<String, AnyObject> {
            cell.selectionStyle = .None
            cell.textLabel?.text = data["title"] as? String
            cell.textLabel?.font = RobotoFont.regular
            cell.detailTextLabel?.text = data["detail"] as? String
            cell.detailTextLabel?.font = RobotoFont.regular
            cell.detailTextLabel?.textColor = MaterialColor.grey.darken1
            cell.imageView?.layer.cornerRadius = 10
            cell.imageView?.clipsToBounds = true
            cell.imageView?.image = UIImage(named: data["icon"] as! String)
        }
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension WechatScreenListController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(WechatMomentsController(), animated: true)
    }
}