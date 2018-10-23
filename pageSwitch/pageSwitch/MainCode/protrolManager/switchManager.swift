//
//  switchManager.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import UIKit

typealias SWPageBack = (_ back:Any) -> Void

struct IBLKeys {
    static var SWPagePram = NSDictionary() /// 页面入参
    static var SWBlockBack = "SWBlockBack" /// 跳转页面的回调
    static var SWSceneType = 0 /// 模态|缓存 状态区分
    static var SWTag = 0 ///页面标示
}

enum IBPageSwitchType {
    case swPresent
    case swPush
}

extension UIViewController{
    
    /// 定义一个类属性作为闭包的容器，专门存放闭包的属性
    class BlockContainer: NSObject, NSCopying {
          func copy(with zone: NSZone? = nil) -> Any {
                return self
          }
        var SWBlockBack: SWPageBack?
    }
    
    /// 页面入参
    var SWPagePram:NSDictionary{
        get{
            return objc_getAssociatedObject(self, &IBLKeys.SWPagePram) as! NSDictionary
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWPagePram, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 页面标示 
    ///
    /// 区分页面来源，方便入参转换
    ///
    var SWTag:Int{
        get{
            return objc_getAssociatedObject(self, &IBLKeys.SWTag) as! Int
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWTag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 模态|缓存 状态区分
    fileprivate var SWSceneType:Int{
        get{
            return objc_getAssociatedObject(self, &IBLKeys.SWSceneType) as! Int
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWSceneType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 定义一个类属性作为闭包的容器，专门存放闭包的属性
    var pageBackContainer:BlockContainer?{
        get{
            if let originalDataBlock = objc_getAssociatedObject(self, &IBLKeys.SWBlockBack) as? BlockContainer {
                return originalDataBlock
            }
            return nil
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWBlockBack, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    fileprivate func SWPresentVC(_ className:String,_ pram:NSDictionary,_ Location: @escaping SWPageBack) -> Void {
        
        //1:动态获取命名空间,开发中应该充分利用guard语句，guard可以有效的解决可选绑定容易形成{}嵌套问题
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        
        //2:根据字符串获取Class
        var cls: AnyClass? = nil
        
        cls = NSClassFromString(name + "." + className)
        
        guard let aClass = cls as? UIViewController.Type else {
            print("aClass不能当做UIViewController")
            return
        }
        
        // 创建blockContainer,将外界传来的闭包赋值给类属性中的闭包变量
        let blockContainer: BlockContainer = BlockContainer()
        blockContainer.SWBlockBack = Location
        
        let vc = aClass.init()
        vc.SWPagePram = pram
        vc.pageBackContainer = blockContainer
        vc.SWSceneType = 0
        
        self.present(vc, animated: true) {
            print("")
        }
        
        guard self.navigationController != nil else {
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    func SWDismissScene(animated: Bool) -> Void {
        if self.SWSceneType == 0 {
            self.dismiss(animated: animated, completion: nil)
        }
        if self.SWSceneType == 1 {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func SWPopToRootVC(animated: Bool) -> Void {
        if self.SWSceneType == 1 {
            self.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
///  SWGoNextVC 页面跳转
///
///  warning : .swPush 状态下要确保'rootNavigationcontroller'存在
///
///  - Parameters:
///     - className :要跳转页面的名字 '~VC'
///     - type      :跳转样式       'swPresent ,swPush'
///     - pram      :要传入的参数
///     - backblock :跳转页面回调block
///
///  - Returns: Void
    
    func SWGoNextVC(_ className:String,_ type:IBPageSwitchType,_ pram:NSDictionary,_ backblock: @escaping SWPageBack) -> Void {
        
        //1:动态获取命名空间,开发中应该充分利用guard语句，guard可以有效的解决可选绑定容易形成{}嵌套问题
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        
        //2:根据字符串获取Class
        var cls: AnyClass? = nil
        
        cls = NSClassFromString(name + "." + className)
        
        guard let aClass = cls as? UIViewController.Type else {
            print("aClass不能当做UIViewController")
            return
        }
        
        // 创建blockContainer,将外界传来的闭包赋值给类属性中的闭包变量
        let blockContainer: BlockContainer = BlockContainer()
        blockContainer.SWBlockBack = backblock
        
        let vc = aClass.init()
        vc.SWPagePram = pram
        vc.pageBackContainer = blockContainer

        /// 模态|缓存 状态记录
        switch type {
        case .swPresent:
            vc.SWSceneType = 0
            self.present(vc, animated: true) {
                print("")
            }
        case .swPush:
            vc.SWSceneType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension UINavigationController{
    
    fileprivate func SWPushVC(_ className:String,_ pram:NSDictionary,_ Location: @escaping SWPageBack) -> Void {
        //1:动态获取命名空间,开发中应该充分利用guard语句，guard可以有效的解决可选绑定容易形成{}嵌套问题
        guard   let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        
        //2:根据字符串获取Class
        var cls: AnyClass? = nil
        
        cls = NSClassFromString(name + "." + className)
        
        guard let aClass = cls as? UIViewController.Type else {
            print("aClass不能当做UIViewController")
            return
        }
        
        // 创建blockContainer,将外界传来的闭包赋值给类属性中的闭包变量
        let blockContainer: BlockContainer = BlockContainer()
        blockContainer.SWBlockBack = Location
        
        let vc = aClass.init()
        vc.SWPagePram = pram
        vc.pageBackContainer = blockContainer
        vc.SWSceneType = 1
        
        self.pushViewController(vc, animated: true)
    }
}
