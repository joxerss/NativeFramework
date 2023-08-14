//
//  MessagesRootViewController.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 20.07.2023.
//

import UIKit

/// Root hittable view controller for presenting Toaster and Alert.
open class MessagesRootViewController: UIViewController {

    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static func instantiate() -> MessagesRootViewController {
        let nibName = String(describing: MessagesRootViewController.self)
        let viewController = MessagesRootViewController(nibName: nibName, bundle: Bundle(for: self))
        viewController.view.backgroundColor = .clear
        viewController.overrideUserInterfaceStyle = .light
        return viewController
    }

}
