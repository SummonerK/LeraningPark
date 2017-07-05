//
//  ModelAddressAddPost.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

//MARK:获取收货地址List postmodel

class ModelAddressListPost: Reflect {
    
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

//MARK:获取收货地址详情 postmodel

class ModelAddressDetailPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!

    /**
     *  收货地址 ID
     *  必传:True
     */
    var deliverId:String!
    
}

//MARK:收货地址新增／修改 postmodel

class ModelAddressAddPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!

    /**
     *  收货地址 ID
     *  必传:True
     */
    var receiverName:String!
    /**
     *  手机号
     *  必传:True
     */
    var receiverPhone:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  区域,省市区，注意是英文-
     *  必传:True
     */
    var area:String!
    /**
     *  详细地址
     *  必传:True
     */
    var address:String!
    /**
     *  详细地址
     *  必传:True
     */
    var isDefault:Int!
    
}

//MARK:收货地址新增／修改 postmodel

class ModelAddressUpdatePost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!

    /**
     *  收货地址 ID
     *  必传:True
     */
    var id:Int!
    /**
     *  收货地址 ID
     *  必传:True
     */
    var receiverName:String!
    /**
     *  收货联系方式
     *  必传:True
     */
    var receiverPhone:String!
    /**
     *  手机号
     *  必传:True
     */
    var phone:String!
    /**
     *  区域,省市区，注意是英文-
     *  必传:True
     */
    var area:String!
    /**
     *  详细地址
     *  必传:True
     */
    var address:String!
    /**
     *  详细地址
     *  必传:True
     */
    var isDefault:Int!
    
}

//MARK:收货地址删除 postmodel

class ModelAddressDeletePost: Reflect {
    
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
     *  收货地址 ID
     *  必传:True
     */
    var id:Int!
    
}


