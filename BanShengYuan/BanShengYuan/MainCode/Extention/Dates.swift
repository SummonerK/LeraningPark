//
//  Dates.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import UIKit

extension Date{
    
    static func date_form(str: String?) -> Date? {
        
        return self.date_from(str: str, formatter: "yyyy-MM-dd HH:mm:ss")
    }
    
    static func date_from(str: String?, formatter: String?) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        if let da_formatter = formatter {
            dateFormatter.dateFormat = da_formatter
            if let time_str = str {
                let date = dateFormatter.date(from: time_str)
                return date
            }
        }
        return nil
    }
    
    func string_from(formatter: String?) -> String {
        
        if let format = formatter {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            let date_str = dateFormatter.string(from: self)
            return date_str
        }
        return ""
    }
    
}

extension String{
    
    var OrderIDFromtimeSP:String{
        let date = NSDate()
        let timeInterval = date.timeIntervalSince1970 * 100000
        return "\(self)_\(Int(timeInterval))"
    }
    
    
}


