//
//  FMColor.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import UIKit

func IBLAnyColor(alpha:CGFloat)->UIColor{
    let anycolor = UIColor.init(hue: (CGFloat(Float(arc4random()%256) / 256.0)), saturation: (CGFloat(Float(arc4random()%256) / 256.0)), brightness: (CGFloat(Float(arc4random()%256) / 256.0)), alpha: alpha)
    return anycolor
}

/// hexColor
public func IBLHexColor(_ hexString: String) -> UIColor{
    
    var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    
    if cString.characters.count < 6 {
        return UIColor.black
    }
    if cString.hasPrefix("0X") {
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
    }
    if cString.hasPrefix("#") {
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
    }
    if cString.characters.count != 6 {
        return UIColor.black
    }
    
    var range: NSRange = NSMakeRange(0, 2)
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    
    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    Scanner.init(string: rString).scanHexInt32(&r)
    Scanner.init(string: gString).scanHexInt32(&g)
    Scanner.init(string: bString).scanHexInt32(&b)
    
    if #available(iOS 10.0, *) {
        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    } else {
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        // Fallback on earlier versions
    }
}

let IBLColorWhite = UIColor.white
let IBLColorSuitMi = IBLHexColor("#E5BB80")
let IBLColorSuitMiRed = IBLHexColor("#A11715")
let IBLColorSuitDeep = IBLHexColor("#220807")
let IBLColorSuitCaffee = IBLHexColor("#764D39")
let IBLColorLHWhiteLight = IBLHexColor("#F5F4F5")
let IBLColorLHGaryLight = IBLHexColor("#E0E0E0")

let FlatLightWhiteF1 = IBLHexColor("#F1F1F1")



































