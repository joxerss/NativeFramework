//
//  NSDate.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 21.07.2023.
//

import Foundation

extension NSDate: Comparable {
    static public func < (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.compare(rhs as Date) == .orderedAscending
    }
}
