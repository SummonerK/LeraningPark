//
//  Views.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit


let StoryBoard_Main = UIStoryboard.init(name: "Main", bundle: nil)
let StoryBoard_Login = UIStoryboard.init(name: "Login", bundle: nil)
let StoryBoard_NextPages = UIStoryboard.init(name: "NextPages_FromHome", bundle: nil)
let StoryBoard_UserCenter = UIStoryboard.init(name: "UserCenter", bundle: nil)
let StoryBoard_ActivityPages = UIStoryboard.init(name: "NextPageActivity", bundle: nil)

//MARK:-设置阴影
func setshadowFor(aview:UIView, OffSet:CGSize){
    aview.layer.shadowColor = UIColor.init(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1).cgColor
    aview.layer.shadowOpacity = 0.7
    aview.layer.shadowRadius = 2
    aview.layer.shadowOffset = OffSet
}

//MARK:-设置圆角
func setRadiusFor(toview:UIView,radius:CGFloat,lineWidth:CGFloat,lineColor:UIColor){
    toview.layer.cornerRadius = radius
    toview.layer.borderColor = lineColor.cgColor
    toview.layer.borderWidth = lineWidth
    toview.layer.masksToBounds = true
}
