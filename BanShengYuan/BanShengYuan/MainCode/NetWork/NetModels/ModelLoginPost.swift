//
//  ModelLoginPost.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import ObjectMapper

//MARK:登录 postmodel

class ModelTestPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var sort:String!
    
}

//MARK:登录 postmodel

class ModelLoginPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  密码，RSA加密
     *  必传:True
     */
    var password:String!

}

//MARK:获取验证码 postmodel

class ModelVCodePost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    
}

//MARK:注册 postmodel

class ModelRegisterPost: Mappable {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  短信验证码
     *  必传:True
     */
    var smsCode:String!
    /**
     *  密码，RSA加密
     *  必传:True
     */
    var password:String!
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        partnerId <- map["partnerId"]
        phone <- map["phone"]
        smsCode <- map["smsCode"]
        password <- map["password"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
    
}

//MARK:修改密码 postmodel

class ModelUpdatePwdPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  短信验证码
     *  必传:True
     */
    var smsCode:String!
    /**
     *  密码，RSA加密
     *  必传:True
     */
    var password:String!
    
}


//MARK:修改密码 postmodel

class ModelVCodeVerifyPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  短信验证码
     *  必传:True
     */
    var smsCode:String!
    
}



