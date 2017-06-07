//
//  Const.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 字体设置
/// 系统普通字体
var IBFontWithSize: (CGFloat) -> UIFont = {size in
    return UIFont.systemFont(ofSize: size);
}

/// 系统加粗字体
var IBBoldFontWithSize: (CGFloat) -> UIFont = {size in
    return UIFont.boldSystemFont(ofSize: size);
}

/// 仅用于标题栏上，大标题字号
let IBNavFont = IBFontWithSize(18);

/// 标题字号
let IBTitleFont = IBFontWithSize(18);

/// 正文字号
let IBBodyFont = IBFontWithSize(16);

/// 辅助字号
let IBAssistFont = IBFontWithSize(14);

// MARK: - 线程队列

/// 主线程队列
let IBMainThread = DispatchQueue.main;
/// Global队列
let IBGlobalThread = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default);

// MARK: - 系统版本

/// 获取系统版本号
let IBSystemVersion = (UIDevice.current.systemVersion as NSString).doubleValue;
/// 是否IOS7系统
let IBIsIOS7OrLater = (UIDevice.current.systemVersion as NSString).doubleValue >= 7 ? true : false;
/// 是否IOS8系统
let IBIsIOS8OrLater = (UIDevice.current.systemVersion as NSString).doubleValue >= 8 ? true : false;
/// 是否IOS9系统
let IBIsIOS9OrLater = (UIDevice.current.systemVersion as NSString).doubleValue >= 9 ? true : false;

// MARK: - 常用宽高

/// 屏幕Bounds
let IBScreenBounds = UIScreen.main.bounds;
/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height;
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width;
/// 导航栏高度
let IBNavBarHeight = 44.0;
/// 状态栏高度
let IBStatusBarHeight = 20.0;
/// Tab栏高度
let IBTabBarHeight = 49.0;

//根据图片名称获取图片
let IBImageWithName: (String) -> UIImage? = {imageName in
    return UIImage(named: imageName);
}

// MARK:封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("☆☆【☆】\(fileName)\t【☆】ATLine:\(line)\t【☆】\(function)\n【☆】LOG:\(message)")
    #endif
}
