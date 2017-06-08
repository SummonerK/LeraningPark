//
//  Login_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import IQKeyboardManagerSwift

class Login_RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = false

        ShowWelecomeV()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowWelecomeV (){
        
        let welecomeV = GuideView.init(frame: UIScreen.main.bounds)
        
        welecomeV.contentImages = {
            
            let array : Array<UIImage> = [BundleImageWithName("guide1")!,BundleImageWithName("guide2")!,BundleImageWithName("guide3")!,BundleImageWithName("guide4")!]
            
            return array
        }
        welecomeV.titles = {
            return ["文章分类,方便阅读","纯黑设计,极客最爱","代码高亮,尊重技术","一键分享,保留精彩"]
        }
        welecomeV.contentSize = {
            return CGSize.init(width: 220, height: 220)
        }
        
        welecomeV.doneButton = {
            let button : UIButton = UIButton(frame:CGRect.init(x: welecomeV.frame.size.width * 0.1, y: welecomeV.frame.size.height - 50, width: welecomeV.frame.size.width * 0.8, height: 33))
            button.setImage(BundleImageWithName("button_start")!, for:UIControlState.normal)
            return button
        }
        
        welecomeV.showGuideView()
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        PrintFM("登录")
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let storyboard_HOME = UIStoryboard.init(name: "Main", bundle: nil)
        window?.rootViewController = storyboard_HOME.instantiateInitialViewController()
        
        let animation = CATransition.init()
        animation.duration = 0.6
//        animation.type = "rippleEffect" //波纹
        animation.type = kCATransitionFade //波纹
        
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
    }

}
