//
//  ModelLoginBack.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK:通用返回结构
/*
 *  statusCode:100
 *  msg:String
 */
class ModelTestBack: Mappable {
    var current_user_url: String?
    var current_user_authorizations_html_url: String?
    var authorizations_url: String?
    var code_search_url: String?
    var commit_search_url: String?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        current_user_url <- map["current_user_url"]
        current_user_authorizations_html_url <- map["current_user_authorizations_html_url"]
        authorizations_url <- map["authorizations_url"]
        code_search_url <- map["code_search_url"]
        commit_search_url <- map["commit_search_url"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:通用返回结构
/*
 *  statusCode:100
 *  msg:String
 */
class ModelCommonBack: Mappable {
    var msg: String?
    var statusCode: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        statusCode <- map["statusCode"]
    }
    
    public var description: String {
        return self.msg!
    }
    
}

//MARK:收货地址 AddressListBack

/*
 {"id":5,
 "partnerId":"a8bee0dd-09d1-4fa9-a9eb-80cb36d3d611",
 "receiverName":null,
 "receiverPhone":"18915966899",
 "phone":"18915966899",
 "area":" 江苏-南京-建邺区",
 "address":"梦都大街51号",
 "isDefault":0}
 
 */

class ModelAddressItem: Mappable {
    var id: Int?
    var partnerId: String?
    var receiverName: String?
    var receiverPhone: String?
    var phone: String?
    var area: String?
    var address: String?
    var isDefault: Int?
    
    init() {}
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        partnerId <- map["partnerId"]
        receiverName <- map["receiverName"]
        receiverPhone <- map["receiverPhone"]
        phone <- map["phone"]
        area <- map["area"]
        address <- map["address"]
        isDefault <- map["isDefault"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:收货地址详细 AddressListBack

class ModelAddressDetail: Mappable {
//    var statusCode: Int?
//    var msg: String?
    
    var receiverName: String?
    var phone: String?
    var area: String?
    var address: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
//        statusCode <- map["statusCode"]
//        msg <- map["msg"]
        receiverName <- map["receiverName"]
        phone <- map["phone"]
        area <- map["area"]
        address <- map["address"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
}
