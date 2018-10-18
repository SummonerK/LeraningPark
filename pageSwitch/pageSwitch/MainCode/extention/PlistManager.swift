//
//  PlistManager.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/18.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation


/// 后台运行音乐 Manager

let IBLPlistM = PlistManager.shared

class PlistManager: NSObject {
    
    fileprivate var musicName:String?
    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    static let shared = PlistManager()
    // 重载并私有
    private override init() {
        PrintFM("audioBackGroundManager 单例")
    }
    
    func IBLPlistArrayFrom(plistName:String) -> NSArray {
        
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            print("资源文件未找到\(plistName).plist .")
            return NSArray()
        }
        
        if let webs = NSArray(contentsOfFile: plistPath) {
            return webs
        }else{
            return NSArray()
        }
    }
    
    func IBLPlistDictionaryFrom(plistName:String) -> NSDictionary {
        
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            print("资源文件未找到\(plistName).plist .")
            return NSDictionary()
        }
        
        if let webs = NSDictionary(contentsOfFile: plistPath) {
            return webs
        }else{
            return NSDictionary()
        }
    }

}
