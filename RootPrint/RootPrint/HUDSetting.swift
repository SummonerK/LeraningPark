//
//  HUDSetting.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/17.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

import SVProgressHUD
import MBProgressHUD

/// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

func HUDShowMsgQuick(_ msg:String,_ time:Float){
    
    let hud = MBProgressHUD.showAdded(to: KeyWindow, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = msg
    hud.tintColor = UIColor.clear
    hud.isUserInteractionEnabled = true
    
    hud.offset = CGPoint.init(x: 0, y: 80)
    
    //延迟隐藏
    hud.hide(animated: true, afterDelay: TimeInterval(time))
}


/// 带状态 提示HUD
func HUDShowNetQuick(_ msg:String,_ status:Int,_ time:Float){
    
    SVProgressHUD.setDefaultMaskType(.gradient)
    
    if status == 1 || status == 0 {
        SVProgressHUD.showSuccess(withStatus: msg)
        
        SVProgressHUD.dismiss(withDelay: TimeInterval(time))
    }else{
        SVProgressHUD.showError(withStatus: msg)
        
        SVProgressHUD.dismiss(withDelay: TimeInterval(time))
    }
    
}

/// 网络加载动画
func SVNetHUDShow() {
    
    SVProgressHUD.setDefaultMaskType(.gradient)
    
    SVProgressHUD.show()
}














