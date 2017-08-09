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
    /**
     *  商户编号
     *  必传:True
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
    var finalPrice: Int?
    
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
    var productNumber: Int?
    
    var stock: Int?
    var remark: String?
    var productSpecification: [NSDictionary]?
    var specificationList: [ModelMenuSpecItem]?

    var chooseFlag: Bool?
    
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
        productNumber <- map["productNumber"]
        
        remark <- map["remark"]
        saleCount <- map["saleCount"]
        sellTimeName <- map["sellTimeName"]
        specification <- map["specification"]
        status <- map["status"]
        type <- map["type"]
        unit <- map["unit"]
        
        
        stock <- map["stock"]
        productSpecification <- map["productSpecification"]
        specificationList <- map["specificationList"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelMenuSpecItem: Mappable {
    var partName: String?
    var value: [String]?
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        partName <- map["partName"]
        value <- map["value"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


// labelItem

class ModelItemLabel: Mappable {
    var lid: Int?
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


//MARK:获取商品详情 postmodel

class ModelGoodsDetailPost: Reflect {

    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var productId:String!

    
}

//MARK:获取商品详情 backModel

class ModelGoodsDetailResult: Mappable {
    var pid: CLongLong?
    var detailText: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        pid <- map["pid"]
        detailText <- map["detailText"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:获取商品详情 图片 postmodel

class ModelGoodsDetailPicturePost: Reflect {
    
    /**
     *  商品ID
     *  必传:True
     */
    var productId:String!
    /**
     *  图片类型
     *  必传:True 默认default，轮播banner
     */
    var type:String!
    
    
}

//MARK:获取商品详情 backModel

class ModelGoodsDetailResultPictures: Mappable {
    var ppid: CLongLong?
    var productId: String?
    var type: CLongLong?
    var url: String?
    var sequence: CLongLong?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        ppid <- map["ppid"]
        productId <- map["productId"]
        type <- map["type"]
        url <- map["url"]
        sequence <- map["sequence"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:商品规格post model

class ModelShopDetailMenuPost: Reflect {
    /**
     *  商品ID
     *  必传:True
     */
    var productId:String!
    var shopId:String!
    
}

//MARK:获商商品规格

class ModelShopDetailDetaiMenuItem: Mappable {
    var errcode: String?
    var errmsg: String?
    var data: ModelMenuPicture?
    
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

class ModelMenuPicture: Mappable {
    var count: Int?
    var products: [ModelShopDetailItem]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["count"]
        products <- map["products"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:搜索门店商品 post model

class ModelSearchProductPost: Reflect {
    var shopId:String!
    var productName:String!
    
}

//MARK:搜索门店返回

class ModelSearchProductResult: Mappable {
    var errcode: String?
    var errmsg: String?
    var data: ModelSearchProductContent?
    
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

class ModelSearchProductContent: Mappable {
    var count: Int?
    var products: [ModelShopDetailItem]?   ///<搜索返回-商品列表
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["count"]
        products <- map["products"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:添加购物车 post model

class ModelShoppingCarAddProductPost: Reflect {
    var userId:String!///用户ID
    var linkId:String!///关联ID：门店ID/商户ID
    var type:String!///关联ID类型: 1=门店，2=商户
    var productId:String!///商品ID
    var name:String!///商品名称
    var number:String!///商品数量
    
}

//MARK:添加购物车返回

class ModelShoppingCarAddResult: Mappable {
    var errcode: String?
    var errmsg: String?
    var data: String?
    
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

//MARK:购物车 post model

class ModelShoppingCarProductsPost: Reflect {
    var userId:String!///用户ID
    var companyId:String!///商户ID
    
}

//MARK:购物车返回

class ModelShoppingCarProductsResult: Mappable {
    var errcode: String?
    var errmsg: String?
    var data: [ModelShoppingCarProducts]?
    
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

class ModelShoppingCarProducts: Mappable {
    var count: Int?
    var linkId: String?
    var products: [ModelShopDetailItem]?
    var scid: Int?
    var type: Int?
    var userId: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["count"]
        linkId <- map["linkId"]
        products <- map["products"]
        scid <- map["scid"]
        type <- map["type"]
        userId <- map["userId"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}




