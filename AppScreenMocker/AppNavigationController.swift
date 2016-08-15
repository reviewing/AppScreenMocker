//
//  AppNavigationController.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/12/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.statusBarStyle = .LightContent
    }
    
    /// Prepares the navigationBar
    private func prepareNavigationBar() {
        navigationBar.tintColor = MaterialColor.white
    }
}
