//
//  resetPwdVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class resetPwdVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let duration = 0.3
    
    @IBAction func resetPwdCompleted(_ sender: Any) {
        
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        
//        //获取根VC
//        var rootVC = self.presentingViewController
//        while let parent = rootVC?.presentingViewController {
//            rootVC = parent
//        }
//        //释放所有下级视图
//        rootVC?.dismiss(animated: true, completion: nil)
        
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
        let animation = CATransition.init()
        animation.duration = duration
        //        animation.type = "rippleEffect" //波纹
        animation.type = kCATransitionFade 
        
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
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
