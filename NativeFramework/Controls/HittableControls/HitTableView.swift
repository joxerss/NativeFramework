//
//  HitTableView.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 21.07.2023.
//

import UIKit

open class HitTableView: UITableView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return self == view ? nil : view
    }
    
}
