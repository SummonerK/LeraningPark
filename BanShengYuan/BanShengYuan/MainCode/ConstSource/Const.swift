//
//  Const.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit

import MBProgressHUD

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

// MARK:根据图片名称获取图片
///从bundle 中获取图片
let IBImageWithName: (String) -> UIImage? = {imageName in
    return UIImage(named: imageName);
}

let BundleImageWithName:(String) ->UIImage? = {imageName in
    
    if let str = Bundle.main.path(forResource: "Source", ofType: "bundle") , let filePath = Bundle(path: str)?.path(forResource: imageName, ofType: "png"){
        return UIImage(contentsOfFile: filePath)
    }else{
        return createImageWithColor(color: UIColor.white)
    }
    
}
///根据颜色获取图片
func createImageWithColor(color: UIColor) -> UIImage
{
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let theImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return theImage!
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

let radius:CGFloat = 40

extension String{
    
    func isTelNumber()->Bool{
        
        let eight = self.length-3
        var seven = self.length-4
        
        if self.length == 3{
            seven = 0
        }
        
        PrintFM("\(self) \(eight),\(seven)")
        
        let IBCM = String.init("^((13[0-2])|(145)|(15[5-6])|(17[0,6])|(18[5,6]))\\d{\(eight)}$|(1709)\\d{\(seven)}$")
        let IBCU = String.init("^((13[4-9])|(147)|(15[0-2,7-9])|(17[0,8])|(18[2-4,7-8]))\\d{\(eight)}$|(1705)\\d{\(seven)}$")
        let IBCT = String.init("^((133)|(153)|(17[3,7,9])|(149)|(18[0,1,9]))\\d{\(eight)}$|(1349)\\d{\(seven)}$")
        
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",IBCM!)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,IBCU!)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,IBCT!)
        if ((regextestcm.evaluate(with: self) == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        }else{
            return false
        } 
    }
    
    var length: Int {
        return self.utf16.count
    }
    
}

// MARK:MBProgressHUD

///-默认菊花样式提示
func HUDdefaultShow(toview:UIView){
    
    let hud = MBProgressHUD.showAdded(to: toview, animated: true)
    hud.label.text = "这是默认带菊花的提示"
    //背景渐变效果
    hud.dimBackground = true
    //延迟隐藏
    hud.hide(animated: true, afterDelay: 0.8)
}

///-纯文本提示
func HUDtextShow(toview:UIView ,msg:String ,subMsg:String){
    let hud = MBProgressHUD.showAdded(to: toview, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = msg
    hud.detailsLabel.text = subMsg
    //延迟隐藏
    hud.hide(animated: true, afterDelay: 0.8)
}

///-自定义视图提示
func HUDcustomShow(toview:UIView){
    
    let hud = MBProgressHUD.showAdded(to: toview, animated: true)
    hud.mode = MBProgressHUDMode.customView
    hud.customView = UIImageView(image: UIImage(named: "item2_activity")!)
//    hud.customView?.backgroundColor = UIColor.clear
    hud.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//    hud.backgroundView.color = UIColor.clear
//    hud.contentColor = UIColor.clear
//    hud.tintColor = UIColor.clear
    hud.bezelView.style = .solidColor
//    hud.label.text = "这是自定义视图"
    //延迟隐藏
    hud.hide(animated: true, afterDelay:3)
}

///-使用异步功能 示例

func HUDasyncShow(toview:UIView){
    
    let hud = MBProgressHUD.showAdded(to: toview, animated: true)
    hud.label.text = "请稍等，数据加载中,预计10秒中"
    
    hud.show(animated: true, whileExecuting: {
        //异步任务，在后台运行的任务
        sleep(10)
    }) {
        //执行完成后的操作，移除
        hud.removeFromSuperview()
    }
}

func HUDShowMsgQuick(msg:String,toView:UIView,time:Float){

    
    let hud = MBProgressHUD.showAdded(to: toView, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = msg
    hud.tintColor = UIColor.clear
    //延迟隐藏
    hud.hide(animated: true, afterDelay: TimeInterval(time))
}


