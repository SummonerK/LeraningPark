//
//  ModelOrder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper

//MARK:创建订单 postmodel

class ModelOrderCreatePost: Reflect {
    /**
     *  商户ID
     *  必传:True 
     */
    var companyId:String!
    /**
     *  门店ID
     *  必传:True
     */
    var shopId:String!
    /**
     *  门店名称
     *  必传:True
     */
    var shopName:String!
    /**
     *  用户ID
     *  必传:True
     */
    var userId:String!
    
    /**
     *  用户名称
     *  必传:True 
     */
    var userName:String!
    /**
     *  用户电话
     *  必传:false
     */
    var phone:String!
    /**
     *  收货地址
     *  必传:false
     */
    var address:String!
    /**
     *  订单类型
     *  必传:True
     */
    var type:Int!
    
    /**
     *  订单状态
     *  必传:True
     */
    var status:Int!
    /**
     *  支付状态
     *  必传:false
     */
    var payStatus:Int!
    /**
     *  支付类型
     *  必传:True
     */
    var payType:Int!
    
    /**
     *  商品列表
     *  必传:True
     */
    var products: [ModelOrderProductItem]?
    
    /**
     *  其他结算列表
     *  必传:True
     */
    var accounts: [ModelOrderAccountItem]?
    
}

class ModelOrderProductItem: Reflect {
    /**
     *  商品ID
     *  必传:True
     */
    var productId:String!
    /**
     *  商品名称
     *  必传:True
     */
    var productName:String!
    /**
     *  商品数量
     *  必传:True
     */
    var number:Int!
    /**
     *  商品单价分
     *  必传:True
     */
    var price:String!
    /**
     *  排序
     *  必传:True
     */
    var sequence:String!
}

class ModelOrderAccountItem: Reflect {
    /**
     *  结算对象ID
     *  必传:True
     */
    var accountId:String!
    /**
     *  结算对象名称
     *  必传:True
     */
    var name:String!
    /**
     *  结算对象类型
     *  必传:True
     */
    var type:Int!
    /**
     *  结算金额
     *  必传:True
     */
    var price:Int!
    /**
     *  结算数量
     *  必传:True
     */
    var number:Int!
    /**
     *  排序
     *  必传:True
     */
    var sequence:Int!
}



//MARK:创建订单返回 backModel

class ModelOrderCreateBack: Mappable {
    var order_id: String?//订单编号
    var payNo: String?//支付编号
    var callBackUrl: String?//支付回调地址
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        payNo <- map["payNo"]
        callBackUrl <- map["callBackUrl"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

