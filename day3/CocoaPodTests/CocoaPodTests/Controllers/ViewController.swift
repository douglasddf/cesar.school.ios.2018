//
//  ViewController.swift
//  CocoaPodTests
//
//  Created by Douglas Frari on 11/05/18.
//  Copyright © 2018 CESAR School. All rights reserved.
//

import UIKit
import SideMenu // <<---- referencia a library cocoapod

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

