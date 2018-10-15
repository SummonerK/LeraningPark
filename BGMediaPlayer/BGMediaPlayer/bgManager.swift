//
//  bgManager.swift
//  bgRefreshNotice
//
//  Created by Luofei on 2018/10/10.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

let BGNM = bgManager.shared

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


let BGNMNoticeName = "BGNMNOTICE"

class bgManager: NSObject {
    
    let constCount: TimeInterval = 500000 //重复查询次数
    var rtcount: TimeInterval = 1 //查询次数记录
    var rtimeCell: TimeInterval = 20 //查询时间间隔
    var rtimer:Timer?

    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    
    static let shared = bgManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    func setRunTimer(){
        
        if rtimer != nil {
            rtcount = 1
        }else{
            rtimer = Timer.init(fireAt: NSDate() as Date, interval: rtimeCell, target: self, selector: #selector(rtpick), userInfo: nil, repeats: true)
            
            RunLoop.current.add(rtimer!, forMode:RunLoopMode.commonModes)
        }
    }
    
    func releasepick(){
        rtimer?.invalidate()
        rtimer = nil
        rtcount = 1
    }
    
    func rtpick() {
        
//        USERM.getLocation { (alocation) in
//            print("编码成功")
//        }
        
        
        if rtcount>=constCount {
            rtimer?.invalidate()
            rtimer = nil
            rtcount = 1
        }else{
            rtcount += 1
            sendPickMessage()
        }
        
    }
    
    
    fileprivate func sendPickMessage(){
        
        print("sendPickMessage")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:BGNMNoticeName), object: nil)
    }

}
