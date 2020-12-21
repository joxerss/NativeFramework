//
//  UIViewController+Material.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 18.07.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showMDCActivityLoader() {
        self.view.showMDCActivity()
    }
    
    func hideMDCActivityLoader() {
        self.view.hideMDCActivity()
    }
    
    func mdcActivityProgressHandler() -> UIView.ActivityProgressHandler {
        return self.view.mdcActivityProgressHandler
    }
    
}
