//
//  MessagesWindow.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 19.07.2023.
//

import UIKit

open class MessagesWindow: UIWindow {
    
    // MARK: - Lifecycle
    
    init() {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first,
               scene.delegate is UIWindowSceneDelegate,
               let windowScene = scene as? UIWindowScene {
                super.init(windowScene: windowScene)
            } else {
                super.init()
            }
        } else {
            super.init()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("❌ \(self)")
    }
    
    // MARK: - Actions
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        let result = self == view ? nil : view
        
       let isKind = view?.subviews.first?.isKind(of: HitView.self) ?? false
       return isKind ? nil :result
        /**
         In case u have someview belowe that doesn't pass touch.
         ```
        let isKind = view?.subviews.first?.isKind(of: HitView.self) ?? false
        return isKind ? nil :result
         ```
        */
    }
    
}
