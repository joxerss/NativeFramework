//
//  ConvertExtensions.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 07.02.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import Foundation

extension Int {
    
    /// Convert time span to date
    func convertToDate() -> Date {
        let myTimeInterval = TimeInterval(self)
        let time: Date = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
        return time
    }
    
}

extension Date {
    
    /// Enum with data formats which used in app.
    ///
    /// You can use the other formats if need:
    /**
     Wednesday, Jul 29, 2020 - **EEEE, MMM d, yyyy**
     
     07/29/2020 - **MM/dd/yyyy**
     
     07-29-2020 19:16 - **MM-dd-yyyy HH:mm**
     
     Jul 29, 7:16 PM - **MMM d, h:mm a**
     
     July 2020 - **MMMM yyyy**
     
     Jul 29, 2020 - **MMM d, yyyy**
     
     Wed, 29 Jul 2020 19:16:47 +0000 - **E, d MMM yyyy HH:mm:ss Z**
     
     2020-07-29T19:16:47+0000 - **yyyy-MM-dd'T'HH:mm:ssZ**
     
     29.07.20 - **dd.MM.yy**
     
     19:16:47.987 - **HH:mm:ss.SSS**
     */
    enum DateFormats: String {
        case usa = "MM/dd/YYYY a"
        case europ = "dd.mm.YYYY"
        case server = "YYYY/MM/dd"
        case MD5 = "dd.MM.Y"
    }
    
    func convertToUTCString(_ format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC") // TimeZone.current
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func convertToString(_ format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func convertToTimeSpan() -> Int {
        Int(self.timeIntervalSince1970)
    }
    
}

extension Data {
    
    func convertToClass<T>(_ classType: T.Type) -> T? where T: Codable {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    func convertToClass<T>(_ classType: [T.Type]) -> [T]? where T: Codable {
            return try? JSONDecoder().decode([T].self, from: self)
    }
    
    func convertFromSnakeCaseToClass<T>(_ classType: [T.Type]) -> [T]? where T: Codable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        /*decoder.keyDecodingStrategy = .custom { keys -> CodingKey in
         let key = keys.last!.stringValue.split(separator: "_").joined()
         return Currency.CodingKeys.init(stringValue: String(key))!
         }*/
        
        return try? decoder.decode([T].self, from: self)
    }
    
}
