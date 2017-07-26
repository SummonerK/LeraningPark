//
//  Colors.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit

let FlatBlackDark = UIColor(hexString: "#1D1D1D")
let FlatBlackLight = UIColor(hexString: "#202020")
let FlatGrayDark = UIColor(hexString: "#6D797A")
let FlatGrayLight = UIColor(hexString: "#849495")
let FlatWhiteDark = UIColor(hexString: "#B0B6BB")
let FlatWhiteLight = UIColor(hexString: "#E8ECEE")
let FlatLocalMain = UIColor(hexString: "#35BBC6")
let FlatLocalWhite = UIColor(hexString: "#FFFFFF")
let FlatLocalWhitelight = UIColor(hexString: "#85F4F4")
let FlatLocalBlack = UIColor(hexString: "#999999")
let FlatLocalLight = UIColor(hexString: "#EDEDED")
let FlatLocalGray = UIColor(hexString: "#CFCDCD")


func AnyColor(alpha:CGFloat)->UIColor{
    let anycolor = UIColor.init(hue: (CGFloat(Float(arc4random()%256) / 256.0)), saturation: (CGFloat(Float(arc4random()%256) / 256.0)), brightness: (CGFloat(Float(arc4random()%256) / 256.0)), alpha: alpha)
    return anycolor
}

