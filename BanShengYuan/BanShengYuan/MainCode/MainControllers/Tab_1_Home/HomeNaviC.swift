//
//  HomeNaviC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class HomeNaviC: UINavigationController {

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
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
