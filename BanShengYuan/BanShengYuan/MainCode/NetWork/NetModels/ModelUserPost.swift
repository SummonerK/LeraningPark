//
//  ModelUserPost.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper

//MARK:个人信息设置／修改 postmodel

class ModelUserUpdateInfoPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  昵称
     *  必传:True
     */
    var nickName:String!
    /**
     *  头像的CDN地址
     *  必传:True
     */
    var avatarUrl:String!
    /**
     *  生日，yyyy-MM-dd
     *  必传:True
     */
    var birthday:String!
    /**
     *  性别
     *  必传:True
     */
    var sex:String!
    
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    
}

//MARK:个人信息设置／修改 postmodel

class ModelUserGetInfoPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  昵称
     *  必传:True
     */
    var phone:String!

    
}

//
class ModelUserInfoBack: Mappable {
    
    var memberId: String?
    var avatarUrl: String?
    var nickName: String?
    var sex: Int?
    var phone: String?
    var birthday: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        memberId <- map["memberId"]
        avatarUrl <- map["avatarUrl"]
        nickName <- map["nickName"]
        sex <- map["sex"]
        phone <- map["phone"]
        birthday <- map["birthday"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}
