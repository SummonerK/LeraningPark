//
//  FMManager.swift
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/24.
//  Copyright © 2017年 fmPay. All rights reserved.
//

import Foundation

public let Manager = FMManager.shareManager()

typealias PayBack =  (String) -> Void

open class FMManager: NSObject {

    static var signalBack:PayBack?
    
    open static let shared = FMManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    open class func shareManager() -> FMManager{
        
        struct Static {
            
            static let kbManager = FMManager()
        }
        
        return Static.kbManager
    }
    
    open func createPay(prams:NSDictionary ,complated:(String) -> Void){
        
        complated("123")
        
    }

}

//封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("☆☆【☆】\(fileName)\t【☆】ATLine:\(line)\t【☆】\(function)\n【☆】LOG:\(message)")
    #endif
}
