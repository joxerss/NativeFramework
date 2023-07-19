//
//  Event.swift
//  NativeFramework
//
//  Created by Artem on 30.10.2019.
//  Copyright © 2019 Sannacode. All rights reserved.
//

import UIKit

open class Event: NSObject {
    
    var name: String = String()
    var dateStart: Date = Date()
    var dateEnd: Date = Date()
    var notes: String = String()
    var isFullDay: Bool = false
    var deepLink: String? = nil
    
    public init(name: String, dateStart: Date, dateEnd: Date?, notes: String, isFullDay: Bool, deepLink: String? = nil) {
        super.init()
        
        self.name = name
        self.dateStart = dateStart
        self.dateEnd = dateEnd != nil ? dateEnd! : dateStart
        self.notes = notes
        self.isFullDay = isFullDay
        self.deepLink = deepLink
    }
    
}

