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
    
    open var IBLVersion:String{
        if let dic = Bundle.main.infoDictionary{
            if let str : String = dic["CFBundleShortVersionString"] as? String {
                return str
            }
        }
        return ""
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

//MARK: MARK
//TODO: TODO
//FIXME:    页面适配iPhoneX

/**
 #Fix IBOutlet
 #fixNaviTop 以距上FixDistance 的控件TOP为绑定对象
 @IBOutlet weak var fixNaviTop: NSLayoutConstraint!
 @IBOutlet weak var fixNaviHeight: NSLayoutConstraint!
 @IBOutlet weak var fixViewBottom: NSLayoutConstraint!
 fixNaviTop.constant = naviXBtonTop
 fixNaviHeight.constant = naviXBarHeight
 fixViewBottom.constant = naviXBtonTop
 
 if #available(iOS 11.0, *) {
 //            CVMain.contentInsetAdjustmentBehavior = .never
 } else {
 self.automaticallyAdjustsScrollViewInsets = false
 }
 
 */

