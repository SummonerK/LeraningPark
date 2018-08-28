//
//  Color.swift
//  CalendarDemo
//
//  Created by Anh Mai on 10/20/17.
//  Copyright © 2017 Anh Mai. All rights reserved.
//

import UIKit

struct Color {
    static let dateColor        = UIColor.black
    static let otherDataColor   = UIColor.lightGray
}


extension Date{
    func string_from(formatter: String?) -> String {
        
        if let format = formatter {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "zh_CN")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            let date_str = dateFormatter.string(from: self)
            return date_str
        }
        return ""
    }
}
