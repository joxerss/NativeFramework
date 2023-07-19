//
//  RegexManager.swift
//  NativeFramework
//
//  Created by Artem on 06.12.2019.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import Foundation

open class RegexManager: NSObject {
    
    /// Result string must look like url
    ///
    /// **regex_urlKeyValues**
    ///
    /// It's intended for parsing rows whitch look like `URL strings`, for get praramets by keys.
    /// ```
    /// **{deepLink}://?UUID=UUIDValue&Name=nameValue**.
    /// ```
    ///  -- parameter separatorsInsideValue:  **. = - space**
    ///
    ///  -- parameter separatorsBetweenValues:  **&**
    ///
    /// You can add new values but for  **parsing by regex**. It must look like:
    /// ```
    /// keyValue=value
    /// ```
    ///
    /// **Notes**
    ///
    /// Create **extension** for this enum to add cases with **new regx expressions**.
    /// **Extension example**
    /// ```
    ///  extension RegexManager.RegexExpressions {
    ///      enum CustomName: String {
    ///          case custom = "regex here"
    ///      }
    ///  }
    /// ```
    enum RegexExpressions: String {
        case regex_urlKeyValues = #"(?<key>\w+)\=(?<value>[-\w]+[.=\-\w+\s]+)"#
    }
    
    static func getUrlValuesDictionary(originalString: String,
                                       _ regexExpressions: RegexManager.RegexExpressions = RegexExpressions.regex_urlKeyValues) -> Array<Dictionary<String, String>> {
        
        let urlString = originalString.replacingOccurrences(of: "%20", with: " ")
        
        let regexp = try? NSRegularExpression(pattern: regexExpressions.rawValue, options: [.caseInsensitive])
        let matches = regexp?.matches(in: urlString,
                                      options: [],
                                      range: NSRange(location: 0, length: urlString.count) )
        
        
        var resultAttay: Array<Dictionary<String, String>> = Array<Dictionary<String, String>>()
        
        matches?.forEach({ (match) in
            let key = Range( match.range(withName: "key"), in: urlString ).map { String(urlString[$0]) }
            let value = Range( match.range(withName: "value"), in: urlString ).map { String(urlString[$0]) }
            
            if key != nil && value != nil {
                resultAttay.append([key! : value!])
            }
        })
        
        return resultAttay
    }
    
}
