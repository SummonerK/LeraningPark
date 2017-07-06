//
//  ModelShop.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/3.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

//MARK:获商户门店列表 postmodel

class ModelShopDetailPost: Reflect {
//    /**
//     *
//     *  必传:True string
//     */
//    var nsukey:String!
    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var shopId:String!
    /**
     *  页数
     *  必传:True int默认10
     */
    var pagesize:Int!
    /**
     *  页号 int默认 1
     *  必传:True
     */
    var pagenumber:Int!
    
}

//MARK:获商户门店列表 backModel

class ModelShopDetailItem: Mappable {
    var barcode: String?
    var category: String?
    var categoryName: String?
    var companyId: String?
    var customerCode: String?
    var finalPrice: Float?
    
    var labelNames: [ModelItemLabel]?
    var name: String?
    var originalPrice: Float?
    var picture: String?
    var pid: String?
    var saleCount: Int?
    
    var sellTimeName: String?
    var specification: String?
    var status: String?
    var type: String?
    var unit: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        barcode <- map["barcode"]
        category <- map["category"]
        categoryName <- map["categoryName"]
        companyId <- map["companyId"]
        customerCode <- map["customerCode"]
        finalPrice <- map["finalPrice"]
        
        labelNames <- map["labelNames"]
        name <- map["name"]
        originalPrice <- map["originalPrice"]
        picture <- map["picture"]
        pid <- map["pid"]
        saleCount <- map["saleCount"]
        
        sellTimeName <- map["sellTimeName"]
        specification <- map["specification"]
        status <- map["status"]
        type <- map["type"]
        unit <- map["unit"]
        
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
class ModelItemLabel: Mappable {
    var lid: String?
    var shopId: String?
    var name: String?
    var type: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        lid <- map["lid"]
        shopId <- map["shopId"]
        name <- map["name"]
        type <- map["type"]
    }
    
    public var description: String {
        return "shopID: \(String(describing: self.shopId))"
    }
    
}
