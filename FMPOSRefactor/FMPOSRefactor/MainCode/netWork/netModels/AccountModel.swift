//
//  AccountModel.swift
//  FMPOS-Master
//
//  Created by 舒圆波 on 18/7/30.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import ObjectMapper


class BindRes: Mappable {
    var partnerName:String?     //商户名
    var storeName: String?      //门店名
    var partnerId: String?      //商户id
    var storeId: String?        //门店id
    var deviceId: String?       //设备id
    var deviceName: String?     //设备名
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        partnerName <- map["partnerName"]
        storeName <- map["storeName"]
        partnerId <- map["partnerId"]
        storeId <- map["storeId"]
        deviceId <- map["deviceId"]
        deviceName <- map["deviceName"]
    }
    
}

//MARK:AppInfo

class ModelAppInfoResult: Mappable {
    var currentVersionReleaseDate: String?
    var releaseNotes: String?
    var version: String?
    var trackViewUrl: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        currentVersionReleaseDate <- map["currentVersionReleaseDate"]
        releaseNotes <- map["releaseNotes"]
        version <- map["version"]
        trackViewUrl <- map["trackViewUrl"]
    }
}

class ModelAppInfo: Mappable {
    var resultCount: Int?
    var results: [ModelAppInfoResult]?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}

class LoginRes: Mappable {
    var liquidation: Int?
    var partnerCode: String?
    var partnerName: String?    //商户名
    var posRole: Int?           //门店权限，根据权限展示功能，2进制,ios第一版暂不控制
    var storeName: String?      //门店名
    var partnerId: String?      //商户id
    var sessionId: String?
    var unifyId: String?
    var storeId: String?        //门店id
    var pwd: String?            //密码
    var userId: String?         //用户名
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        liquidation <- map["liquidation"]
        partnerCode <- map["partnerCode"]
        partnerName <- map["partnerName"]
        posRole <- map["posRole"]
        sessionId <- map["sessionId"]
        storeName <- map["storeName"]
        partnerId <- map["partnerId"]
        storeId <- map["storeId"]
        unifyId <- map["unifyId"]
        pwd <- map["pwd"]
        userId <- map["userId"]
    }
}

class BindReq: Mappable {
    var appVer: String?         //版本号
    var deviceId: String?       //设备id
    var deviceName: String?     //设备名
    var partnerId: String?      //商户id
    var storeId: String?        //门店id
    var systemVer: String?      //设备系统版本 (ios)
    var op: String?             //func 固定 BindPos
    
    init() {
        appVer = "1.0.0"
        deviceId = "ios_fm99999"    //真实用设备号
        deviceName = "iphone8"
        partnerId = "1371"
        storeId = "fm99999"
        systemVer = "ios11.1"
        op = "BindPos"
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        appVer <- map["appVer"]
        deviceId <- map["deviceId"]
        deviceName <- map["deviceName"]
        partnerId <- map["partnerId"]
        storeId <- map["storeId"]
        systemVer <- map["systemVer"]
        op <- map["op"]
    }
}

class LoginReq: Mappable {
    var deviceId: String?
    var partnerId: String?
    var pwd: String?
    var storeId: String?
    var userId: String?
    var op: String?             //func 固定 LoginPos
    
    init() {
        deviceId = "ios_fm99999"
        partnerId = "1371"
        pwd = "fm99999"
        storeId = "fm99999"
        userId = "fm99999"
        op = "LoginPos"
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        deviceId <- map["deviceId"]
        pwd <- map["pwd"]
        partnerId <- map["partnerId"]
        storeId <- map["storeId"]
        userId <- map["userId"]
        op <- map["op"]
    }
}
//MARK: 获取更新信息
class UpdateReq: Mappable {
    var partnerId: String?
    var appId: String?
    var op: String?             //func 固定 FindAppUpdatePos
    
    init() {
        
        partnerId = "1371"
        appId = "mdl_ios"
        op = "FindAppUpdatePos"
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        appId <- map["appId"]
        partnerId <- map["partnerId"]
        
        op <- map["op"]
    }
}

//MARK: 更新响应
class UpdateRes: Mappable{
    var previousVersionCode:String?
    var previousVersion: String?
    var partnerId: String?
    var editDate: String?
    var appSize: String?
    var appName: String?
    var editUser: String?
    
    var lastVersion:String?
    var lastVersionCode: String?        //最新的版本 int值 暂时只关注这个
    var downloadUrl: String?
    var newFunction: String?
    required init?(map: Map) { }
    
//    override func mapping(map: Map) {
    func mapping(map: Map) {
        lastVersion <- map["lastVersion"]
        lastVersionCode <- map["lastVersionCode"]
        downloadUrl <- map["downloadUrl"]
        newFunction <- map["newFunction"]
        
        previousVersionCode <- map["previousVersionCode"]
        previousVersion <- map["previousVersion"]
        partnerId <- map["partnerId"]
        editDate <- map["editDate"]
        appSize <- map["appSize"]
        appName <- map["appName"]
        editUser <- map["editUser"]
    }
    
    
}
