//
//  IBTabC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import DynamicColor

class IBTabC: UITabBarController {
    static var mytab:IBTabC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false //半透明
        self.tabBar.tintColor = UIColor(hexString: "#f3b919")
        
        NotificationCenter.default.addObserver(self, selector: #selector(BadgeCHange(_:_:)), name: NSNotification.Name(rawValue: "TiltleNotification"), object: nil)
        
        
        //注册了一个名字叫做TiltleNotification的通知，同时<span style="font-family: Arial, Helvetica, sans-serif;">TiltleNotification负责处理传递的通知（）</span>
        
        // Do any additional setup after loading the view.
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension UITabBarController{
    
    func BadgeCHange(_ value:Int ,_ index:Int){
        let item = self.tabBar.items![index]
        item.badgeValue = "value"
    }
    
}
