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

class ModelAddressItem: Mappable {
    var id: Int?
    var partnerId: String?
    var receiverName: String?
    var phone: String?
    var area: String?
    var address: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        partnerId <- map["partnerId"]
        receiverName <- map["receiverName"]
        phone <- map["phone"]
        area <- map["area"]
        address <- map["address"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:收货地址详细 AddressListBack

class ModelAddressDetail: Mappable {
    var statusCode: Int?
    var msg: String?
    var receiverName: String?
    var phone: String?
    var area: String?
    var address: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        msg <- map["msg"]
        receiverName <- map["receiverName"]
        phone <- map["phone"]
        area <- map["area"]
        address <- map["address"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
}
