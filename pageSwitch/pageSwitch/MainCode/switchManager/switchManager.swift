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
    static var SWPagePram = NSDictionary()
    static var SWBlockBack = "SWBlockBack"
    static var SWSceneType = 0
}

extension UIViewController{

    // 定义一个类属性作为闭包的容器，专门存放闭包的属性
    class BlockContainer: NSObject, NSCopying {
          func copy(with zone: NSZone? = nil) -> Any {
                return self
          }
        var SWBlockBack: SWPageBack?
    }
    
    var SWPagePram:NSDictionary{
        get{
            return objc_getAssociatedObject(self, &IBLKeys.SWPagePram) as! NSDictionary
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWPagePram, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var SWSceneType:Int{
        get{
            return objc_getAssociatedObject(self, &IBLKeys.SWSceneType) as! Int
        }
        set{
            objc_setAssociatedObject(self, &IBLKeys.SWSceneType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
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
    
    func SWPresentVC(_ className:String,_ pram:NSDictionary,_ Location: @escaping SWPageBack) -> Void {
        
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
    }
    
    func SWDismissScene(animated: Bool) -> Void {
        if self.SWSceneType == 0 {
            self.dismiss(animated: animated, completion: nil)
        }
        if self.SWSceneType == 1 {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
}

extension UINavigationController{
    
    func SWPushVC(_ className:String,_ pram:NSDictionary,_ Location: @escaping SWPageBack) -> Void {
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
