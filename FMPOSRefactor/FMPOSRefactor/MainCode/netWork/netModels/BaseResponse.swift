//
//  BaseResponse.swift
//  FMPOS-Master
//
//  Created by 舒圆波 on 18/7/30.
//  Copyright © 2018年 FreeMud. All rights reserved.
//


import Foundation
import ObjectMapper

class BaseResponse<T:Mappable>: Mappable {
    var errCode:Int?        //账户接口0为成功 支付接口100为成功
    var errMsg:String?
    var data:T?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        errCode <- map["errcode"]
        errMsg <- map["errmsg"]
        data <- map["data"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
}


class ResultRes: Mappable {
    var msg: String?
    var result: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        result <- map["result"]
    }
}
