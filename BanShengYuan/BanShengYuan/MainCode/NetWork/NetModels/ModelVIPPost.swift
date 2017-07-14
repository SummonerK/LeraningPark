//
//  ModelShop.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/30.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper

//MARK:获商户门店列表 postmodel

class ModelShopListPost: Reflect {
    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var op:String!
    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var partnerId:String!
    /**
     *  页数
     *  必传:True int默认10
     */
    var pageSize:Int!
    /**
     *  页号 int默认 1
     *  必传:True
     */
    var pageNo:Int!
    
}

//MARK:获商户门店列表 backModel

class ModelShopItem: Mappable {
    var address: String?
    var briefName: String?
    var latitude: String?
    var businessHours: String?
    var fullName: String?
    var active: String?
    
    var remark: String?
    var deliveryPrice: Int?
    var typeFlag: Int?
    var phone: String?
    var storeName: String?
    var businessImages: [shanghuPicture]?
    
    var deliveryRadius: Int?
    var storeCode: String?
    var longitude: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        address <- map["address"]
        briefName <- map["briefName"]
        latitude <- map["latitude"]
        businessHours <- map["businessHours"]
        fullName <- map["fullName"]
        active <- map["active"]
        
        remark <- map["remark"]
        deliveryPrice <- map["deliveryPrice"]
        typeFlag <- map["typeFlag"]
        phone <- map["phone"]
        storeName <- map["storeName"]
        businessImages <- map["businessImages"]
        
        deliveryRadius <- map["deliveryRadius"]
        storeCode <- map["storeCode"]
        longitude <- map["longitude"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class shanghuPicture: Mappable {
    var sortIndex: Int?
    var imageUrl: String?
    var imageTitle: ModelShopItem?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        sortIndex <- map["sortIndex"]
        imageUrl <- map["imageUrl"]
        imageTitle <- map["imageTitle"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:获商户门店列表 postmodel

class ModelShopPost: Reflect {
    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var op:String!
    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var partnerId:String!
    /**
     *  页数
     *  必传:True int默认10
     */
    var storeCode:String!
    /**
     *  页号 int默认 1
     *  必传:True
     */
    var typeFlag:String!
    
}

class ModelShopBack: Mappable {
    var errcode: Int?
    var errmsg: String?
    var data: ModelShopItem?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
        data <- map["data"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelShopPage: Mappable {
    var sortIndex: String?
    var imageUrl: String?
    var imageTitle: String?
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        sortIndex <- map["sortIndex"]
        imageUrl <- map["imageUrl"]
        imageTitle <- map["imageTitle"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

