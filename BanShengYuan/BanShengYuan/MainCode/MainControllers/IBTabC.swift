//
//  IBTabC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import DynamicColor

class IBTabC: UITabBarController,UITabBarControllerDelegate{
    static var mytab:IBTabC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false //半透明
        self.tabBar.tintColor = UIColor(hexString: "#f3b919")
        
        NotificationCenter.default.addObserver(self, selector: #selector(BadgeCHange(_:_:)), name: NSNotification.Name(rawValue: "TiltleNotification"), object: nil)
        
        self.delegate = self
        
        //注册了一个名字叫做TiltleNotification的通知，同时TiltleNotification负责处理传递的通知
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        
//        let shouldIndex =  tabBarController.viewControllers?.index(of: viewController)
//        
//        PrintFM("selectedIndex = \(selectedIndex),shouldIndex=\(String(describing: shouldIndex))")
        
        if self.viewControllers?[3] == viewController{
            PrintFM("第三页面，要加控制咯")
            if USERM.MemberID != ""{
                
                return true
                
            }else{
                
                LoginAdjust()
                
                return false
            }
            
        }else{
            return true
        }
        
    }
    

}



extension UITabBarController{
    
    func BadgeCHange(_ value:Int ,_ index:Int){
        let item = self.tabBar.items![index]
        item.badgeValue = "value"
    }
    
}
