//
//  MainTabC.swift
//  ZHX_major
//
//  Created by 李嘉图 on 2019/3/1.
//  Copyright © 2019 freemud. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import DynamicColor

let IBSB_home = UIStoryboard.init(name: "home", bundle: nil)
let IBSB_center = UIStoryboard.init(name: "center", bundle: nil)
let IBSB_mine = UIStoryboard.init(name: "mine", bundle: nil)
let IBSB_category = UIStoryboard.init(name: "category", bundle: nil)
let IBSB_spCar = UIStoryboard.init(name: "spCar", bundle: nil)


///根据颜色获取图片
func createImageWithColor(color: UIColor) -> UIImage
{
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let theImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return theImage!
}


class MainTabC: ESTabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = delegate
        self.title = "Irregularity"
        self.tabBar.shadowImage = UIImage(named: "transparent")
        self.tabBar.backgroundImage = UIImage(named: "background")
        self.shouldHijackHandler = {
            tabbarController, viewController, index in
            return false
        }
        
        let v1 = IBSB_home.instantiateInitialViewController()!
        let v2 = IBSB_center.instantiateInitialViewController()!
        let v3 = IBSB_mine.instantiateInitialViewController()!
        
//        let image_home_n = UIImage(named:"tab_home")?.withRenderingMode(.alwaysOriginal)
//        let image_home_s = UIImage(named:"tab_home_selected")?.withRenderingMode(.alwaysOriginal)
        
        let image_center_n = UIImage(named:"tab_likelife")?.withRenderingMode(.alwaysOriginal)
        let image_center_s = UIImage(named:"tab_likelife_selected")?.withRenderingMode(.alwaysOriginal)
        
        let image_mine_n = UIImage(named:"tab_me")?.withRenderingMode(.alwaysOriginal)
        let image_mine_s = UIImage(named:"tab_me_selected")?.withRenderingMode(.alwaysOriginal)
        
//        v1.tabBarItem = UITabBarItem.init(title: "首页", image: image_home_n, selectedImage: image_home_s)
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "首页", image: UIImage(named:"tab_home"), selectedImage: UIImage(named:"tab_home_selected"), tag: 0)
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: "爱生活", image: image_center_n, selectedImage: image_center_s, tag: 1)
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "我", image: image_mine_n, selectedImage: image_mine_s, tag: 2)
        
        self.viewControllers = [v1, v2, v3]
        // Do any additional setup after loading the view.
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
