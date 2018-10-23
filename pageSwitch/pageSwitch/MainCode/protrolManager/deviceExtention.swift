//
//  deviceExtention.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/17.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation

let IBLDeviceIPad = UIDevice.current.userInterfaceIdiom == .pad

extension UIDevice{
    open var isIPad:Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}


/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width

/// iphone X
let isIphoneX = IBScreenHeight == 812 ? true : false
/// Navi高度
let naviXBarHeight : CGFloat = isIphoneX ? 88 : 64
/// Navi Title YFlex
let naviXBtonTop:CGFloat = isIphoneX ? 44 : 20
/// Bottom高度
let bottmXBtonH:CGFloat = isIphoneX ? 49+34 : 49


// MARK: - Home Different

let IBLDiff_home_itemNum:CGFloat = IBLDeviceIPad ? 5 : 3
let IBLDiff_home_space:CGFloat = IBLDeviceIPad ? 20 : 10
let IBLDiff_home_itemHeight:CGFloat = IBLDeviceIPad ? 60 : 44
