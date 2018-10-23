//
//  IBLPageManager.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/22.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation

let StoryBoard_Login = UIStoryboard.init(name: "FMPOSLogin", bundle: nil)

func LoginAdjust(){
    
//    let isLogin:String = FMLFileM.getPosValue(POSISUserLogin)
//    
//    let isLoginManager = (isLogin == "1" ? true : false)
    
    let isLoginManager = false
    
    if !isLoginManager{
        
        let Vc = StoryBoard_Login.instantiateViewController(withIdentifier: "LoginNaviC") as! LoginNaviC
        
        UIApplication.shared.keyWindow?.rootViewController?.present(Vc, animated: true, completion: nil)
    }
    
}

