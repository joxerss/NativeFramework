//
//  UINavigationController+Extensions.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 10.07.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// Make Navigation Bar transparant.
    func makeNavigationTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
}
