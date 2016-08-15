//
//  AppBottomNavigationController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/12/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

class AppHomeController: UIViewController {
    
    /// NavigationBar menu button.
    private var menuButton: IconButton!
    
    /// A list of all the data source items.
    private var dataSourceItems: Array<MaterialDataSourceItem>!
    
    /// A tableView used to display items.
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
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBar.backgroundColor = MaterialColor.purple.darken1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMenuButton()
        prepareNavigationItem()
        prepareView()
        prepareItems()
        prepareTableView()
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Handles the menuButton.
    internal func handleMenuButton() {
    }
    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = MaterialIcon.cm.image
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "截图构造"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        navigationItem.leftControls = [menuButton]
    }
    
    /// Prepares the items Array.
    private func prepareItems() {
        dataSourceItems = [
            MaterialDataSourceItem(
                data: [
                    "title": "微信",
                    "detail": "支持6种界面",
                    "icon": "Wechat",
                    "goto": "WechatScreenList"
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
extension AppHomeController: UITableViewDataSource {
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
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "MaterialTableViewCell")
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
extension AppHomeController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		navigationController?.pushViewController(WechatScreenListController(), animated: true)
    }
}