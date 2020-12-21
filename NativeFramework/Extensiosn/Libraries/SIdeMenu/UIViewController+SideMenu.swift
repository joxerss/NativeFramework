//
//  UIViewController+SideMenu.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 02.07.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit
import SideMenu

extension UIViewController {
    
    // MARK: - Side Menu
    
    public static func deleteSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = nil
    }
    
    public func attachSideMenu() {
        
        // Define the menus
        if SideMenuManager.default.leftMenuNavigationController == nil {
            let menuController = UIViewController.initContoller(UIStoryboard.main, identifier: UIViewController.sideMenuViewController)
            let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuController)
            SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
            
            // (Optional) Prevent status bar area from turning black when menu appears:
            leftMenuNavigationController.statusBarEndAlpha = 0
            menuController.loadViewIfNeeded()
            
            SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle = .menuSlideIn
            SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle.menuOnTop = true
            SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle.onTopShadowRadius = 25.0
            SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle.onTopShadowOpacity = 0.5

            // Setup gestures: the left and/or right menus must be set up (above) for these to work.
            // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        }
        
        // Attach left side menu (Like Android)
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menu_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showSideMenuAction(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: button)
        barItem.style = .plain
        
        let width = barItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        width!.isActive = true
        
        let height = barItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        height!.isActive = true
        
        //assign button to navigationbar
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func showSideMenuAction(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
}

/*extension UIViewController: SideMenuNavigationControllerDelegate {

    public func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    public func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    public func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    public func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}*/
