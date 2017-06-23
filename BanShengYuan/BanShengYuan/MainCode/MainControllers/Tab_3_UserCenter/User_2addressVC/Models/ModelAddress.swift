//
//  ModelAddress.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/22.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ModelAddress: Reflect {

    /**
     *  收货人
     */
    var name:String!
    /**
     *  联系方式
     */
    var phone:String!
    /**
     *  所在区域
     */
    var address_area:String!
    /**
     *  详细地址
     */
    var address_Detail:String!
    /**
     *  设置默认
     */
    var isFirst:Bool! = false
    
}
