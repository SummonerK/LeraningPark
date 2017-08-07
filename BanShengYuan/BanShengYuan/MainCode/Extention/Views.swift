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


//抖动方向枚举
public enum ShakeDirection: Int {
    case horizontal  //水平抖动
    case vertical  //垂直抖动
}

extension UIView {
    /**
     扩展UIView增加抖动方法
     
     @param direction：抖动方向（默认是水平方向）
     @param times：抖动次数（默认5次）
     @param interval：每次抖动时间（默认0.1秒）
     @param delta：抖动偏移量（默认2）
     @param completion：抖动动画结束后的回调
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
                //如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }
}

func LoginAdjust(){
    
    if USERM.MemberID != ""{
        
    }else{
        
        let Vc = StoryBoard_Login.instantiateViewController(withIdentifier: "LoginNaviC") as! LoginNaviC
        UIApplication.shared.delegate?.window??.rootViewController?.present(Vc, animated: true, completion: nil)
        
    }
}
