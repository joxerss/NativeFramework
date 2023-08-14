//
//  ToasterModel.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 19.07.2023.
//

import UIKit

public typealias ToasterAction = (() -> Void)

/// Posible toaster types.
public enum ToasterType {
    // Displays simple text.
    case text(msg: String)
    // Displays attributed text.
    case attributed(msg: NSAttributedString)
    /// Displays count down timer with one addition action if need.
    case countDown(msg: String, time: TimeInterval, action: ToasterActionModel)
}

/// Position where toaster must be shown.
/*
public enum ToasterPosition {
    case top
    case bottom
}
 */

public enum ToasterPriority: Int {
    case normal = 0
    case emergency
}

/// Model describes concrete toast UI and behaviour.
open class ToasterModel: NSObject {
    
    let type: ToasterType
    let priority: ToasterPriority
    let icon: UIImage?
    let action: ToasterAction? // tap on a body.
    
    init(type: ToasterType,
         priority: ToasterPriority,
         icon: UIImage?,
         action: ToasterAction?) {
        self.type = type
        self.priority = priority
        self.icon = icon
        self.action = action
    }
    
}

open class ToasterActionModel {
    
    let titleAction: String
    let completionAction: ToasterAction
    
    init(titleAction: String, completionAction: @escaping ToasterAction) {
        self.titleAction = titleAction
        self.completionAction = completionAction
    }
    
}
