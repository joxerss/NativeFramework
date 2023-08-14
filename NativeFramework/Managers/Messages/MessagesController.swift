//
//  MessagesController.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 19.07.2023.
//

import UIKit

public typealias PresentToastCompletion = (() -> Void)

/// Protocol for communication between MessagesController and ToastersPresenter (Queue).
/// This is internal one for communication.
protocol ToastersPresenterActions {
    func presentToaster(_ toaster: ToasterModel)
    func dismissToaster(_ toaster: ToasterModel)
}

// MARK: -

/// Protocol which describes all possible options to show toasters.
/// This is public one.
public protocol ToastersActions {
    
    /// Prestent toaster for user.
    /// - Parameters:
    ///   - toaster: describing of message filling and UI model.
    func showToaster(_ toaster: ToasterModel)
    
    /// Dismiss toater from UI.
    func removeToaster(_ toaster: ToasterModel)
}

// MARK: -

// ToastersPresenter is responsible of takeing message into queue and show when it will be possible.
open class MessagesController {
    
    
    // MARK: - Properties
    
    /// Window to display alerts and toaster.
    private lazy var messageWindow: MessagesWindow = {
        let window = MessagesWindow()
        window.backgroundColor = .clear
        window.windowLevel = .alert
        window.makeKeyAndVisible()
        return window
    }()
    
    /// Root window controller.
    private lazy var messagesRootViewController: MessagesRootViewController = {
        return .instantiate()
    }()
    
    //
    private let toastersRouter = ToastersRouter()
    
    // MARK: - Lifecycle
    
    init() {
        messageWindow.rootViewController = messagesRootViewController
        
        // Configure Toasters
        toastersRouter.toastersViewController.willMove(toParent: messagesRootViewController)
        messagesRootViewController.addChild(toastersRouter.toastersViewController)
        messagesRootViewController.view.attach(toastersRouter.toastersViewController.view)
        toastersRouter.toastersViewController.didMove(toParent: toastersRouter.toastersViewController)
    }
    
}

// MARK: - ToastersActions

extension MessagesController: ToastersActions {
    public func showToaster(_ toaster: ToasterModel) {
        toastersRouter.presentToaster(toaster)
    }
    
    public func removeToaster(_ toaster: ToasterModel) {
        toastersRouter.dismissToaster(toaster)
    }
}
