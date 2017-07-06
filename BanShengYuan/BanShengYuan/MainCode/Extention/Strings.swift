//
//  Strings.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit

func FontPFMedium(size:CGFloat)->UIFont{
    
//    return UIFont(name: "PingFangSC-Medium", size: size)!
    return IBFontWithSize(size)
    
}

func FontPFRegular(size:CGFloat)->UIFont{
    
//    return UIFont(name: "PingFangSC-Regular", size: size)!
    return IBFontWithSize(size)
    
}

func FontPFThin(size:CGFloat)->UIFont{
    
//    return UIFont(name: "PingFangSC-Thin", size: size)!
    return IBFontWithSize(size)
    
}

func FontPFLight(size:CGFloat)->UIFont{
    
//    return UIFont(name: "PingFangSC-Light", size: size)!
    return IBFontWithSize(size)
    
}

//MARK:-设置底部画线的attributeString
func setCenterLineToString(tocolor:UIColor) -> [String:Any] {
    let firstAttributes = [NSForegroundColorAttributeName:tocolor,NSStrikethroughColorAttributeName: tocolor, NSStrikethroughStyleAttributeName:1,NSStrokeColorAttributeName:tocolor] as [String : Any]
    
    return firstAttributes
}

//MARK:-设置底部画线的attributeString
func setUnderLineToString(tocolor:UIColor) -> [String:Any] {
    let firstAttributes = [NSForegroundColorAttributeName:tocolor,NSUnderlineColorAttributeName: tocolor, NSUnderlineStyleAttributeName:1,NSStrokeColorAttributeName:tocolor] as [String : Any]
    
//    let firstAttributes = [NSForegroundColorAttributeName:tocolor] as [String : Any]
    
//    let firstAttributes = [NSForegroundColorAttributeName:tocolor,NSStrikethroughColorAttributeName: tocolor, NSStrikethroughStyleAttributeName:1,NSStrokeColorAttributeName:tocolor,NSFontAttributeName:FontPFLight(size: 12)] as [String : Any]
    
//    attributedString.addAttributes(firstAttributes, range: string.rangeOfString("Testing"))
    return firstAttributes
}


extension String{
    
    func fixNumString() -> String {
        
        let acount:Float = self.floatValue!
        
        if acount == 0 || acount < 0 {
            return "0"
        }
        
        if acount > 10000 {
            return "\(String(format: "%.1f 万 ", (acount/10000)))"
        }
        
        return "\(String(format: "%.0f", (acount)))"
    }
}
