//
//  Strings.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

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

func FontLabelPFLight(size:CGFloat)->UIFont{
    
    return UIFont(name: "PingFangSC-Light", size: size)!
    
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

//numberStyle:
public enum Style : UInt {
    
    case none //1234567.89
    
    case decimal //1,234,567.89
    
    case currency //￥1,234,567.89
    
    case percent //123,456,789%
    
    case scientific //1.23456789E6
    
    case spellOut //一百二十三万四千五百六十七点八九
    
//    @available(iOS 9.0, *)
//    case ordinal //第123,4568
//    
//    @available(iOS 9.0, *)
//    case currencyISOCode //CNY1,234,567.89
//    
//    @available(iOS 9.0, *)
//    case currencyPlural//1,234,567.89人民币
//    
//    @available(iOS 9.0, *)
//    case currencyAccounting//￥1,234,567.89
    
}

extension String{
    
    func fixPrice() -> String {
        
        let formatter = NumberFormatter()
        let value = self.doubleValue
        let format = NSMutableString(string: "###,##0.")
        let precision = 2
        if(precision == 0)
        {
            formatter.positiveFormat = format as String
            return formatter.string(from: NSNumber(value: value!/100))!
            
        }
        else
        {
            for _ in 1...precision
            {
                format.appendFormat("0")
            }
            formatter.positiveFormat = format as String
            return formatter.string(from: NSNumber(value: value!/100))!
        }
        
    }
    
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
    
    
    /**
     根据 正则表达式 截取字符串
     
     - parameter regex: 正则表达式
     
     - returns: 字符串数组
     */
    public func matchesForRegex(regex: String) -> [String]? {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.characters.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
    
    
    var array_items:[String]{
        
//        let regex = "<img\\b(?=\\s)(?=(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"][^\\s>]*)*?\\ssrc=['\"]([^\"]*)['\"]?)(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"\\s]*)*\"\\s?\\/?>"
//       
//        // 截取img标签
//        let resultItems = self.matchesForRegex(regex)
        
        let regex = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
        
        // 截取所有img url
        let resultItems = self.matchesForRegex(regex: regex)
        
//        for item in resultItems! {
//            let url = URL(string: item)
//            let imageV = UIImageView.init()
//            imageV.kf.setImage(with: url)
//        }
        
        return resultItems!
        
    }
    
    var array_itemPace:[String]{
        
        //        let regex = "<img\\b(?=\\s)(?=(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"][^\\s>]*)*?\\ssrc=['\"]([^\"]*)['\"]?)(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"\\s]*)*\"\\s?\\/?>"
        //
        //        // 截取img标签
        //        let resultItems = self.matchesForRegex(regex)
        
//        let regex = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
        
        // 截取所有img url
        let resultItems = self.components(separatedBy: "~")
        
        let array = NSMutableArray()
        
        
        for item in resultItems {
            
//            let url = URL(string: item)
//            let imageV = UIImageView.init()
//            imageV.kf.setImage(with: url)
            
            let item_temp = item.replacingOccurrences(of: "\r\n", with: "")
            
            array.add(item_temp)
            
        }
        
        return array as! [String]
        
    }
    //计算字串宽高
    func getLabSize(font:UIFont) -> CGSize {
        
        let statusLabelText: NSString = self as NSString
        
        let size = CGSize.init(width: 900, height: 22)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        
        return strSize
    }
    
    var sectoryPhone:String{
        
        let a = NSString(string:self)
        let myNSRange = NSRange(location: 3, length: 4)
        let str = a.replacingCharacters(in: myNSRange, with: "****")
        
        return str
    }
    
    var trueItemValue:String{
        
        if self == "color"{
            return "颜色"
        }
        if self == "size"{
            return "尺寸"
        }
        if self == "zipper"{
            return "拉链"
        }
        
        return ""
        
    }
    
}
