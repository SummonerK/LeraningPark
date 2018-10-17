//
//  BaseSetting.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation

/// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

/// MARK:封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("【☆☆】\(fileName)\t【☆】func:\(function)\t【☆】ATLine:\(line)\n【☆】LOG:\(message)")
    #endif
}
