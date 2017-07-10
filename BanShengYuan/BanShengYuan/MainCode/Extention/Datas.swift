//
//  Datas.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

let BSYPHONE = "BSYPHONE"
let BSYPWD = "BSYPWD"
let BSYUSERID = "BSYUSERID"

let USERM = UserManager.shared

let userDefault = UserDefaults.standard

class UserManager: NSObject {
    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    
    static let shared = UserManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    var Phone:String{
        
        if let str = userDefault.value(forKey: BSYPHONE){
            return str as! String
        }else{
            return ""
        }
    }
    var Pwd:String{
        if let str = userDefault.value(forKey: BSYPWD){
            return str as! String
        }else{
            return ""
        }
    }
    var UserID:String{
        if let str = userDefault.value(forKey: BSYUSERID){
            return str as! String
        }else{
            return ""
        }
    }
    
    func setPhone(phone:String){
        userDefault.set(phone, forKey: BSYPHONE)
    }
    
    func setPwd(pwd:String){
        userDefault.set(pwd, forKey: BSYPWD)
    }
    
    func setUserID(uid:String){
        userDefault.set(uid, forKey: BSYUSERID)
    }
    
}
