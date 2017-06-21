//
//  LoginNaviC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class LoginNaviC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:-NavigationBar背景颜色
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        //MARK:-NavigationBar文字颜色
        
        let textAttr = [NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName: FontPFThin(size: 17)]
        UINavigationBar.appearance().titleTextAttributes = textAttr
        
        UINavigationBar.appearance().tintColor = FlatBlackDark
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
