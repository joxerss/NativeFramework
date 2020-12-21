//
//  Bundle+Extenstions.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 10.07.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
