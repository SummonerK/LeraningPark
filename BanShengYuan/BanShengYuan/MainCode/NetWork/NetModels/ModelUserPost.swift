//
//  ModelUserPost.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

//MARK:个人信息设置／修改 postmodel

class ModelUserUpdateInfoPost: Reflect {
    
    /**
     *  商户编号
     *  必传:True
     */
    var partnerId:String!
    /**
     *  会员编号
     *  必传:True
     */
    var memberId:String!
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
    
}
