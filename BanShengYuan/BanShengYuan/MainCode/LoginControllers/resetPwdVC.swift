//
//  resetPwdVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift

class resetPwdVC: UIViewController {

    @IBOutlet weak var tf_fistPwd: UITextField!
    
    @IBOutlet weak var tf_againPwd: UITextField!
    
    @IBOutlet weak var bton_resetPwd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRadiusFor(toview: bton_resetPwd, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true
        
        setNavi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "忘记密码"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
        
//        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        //        animation.type = "rippleEffect" //波纹
//        animation.type = kCATransitionFade 
//        
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
        self.navigationController?.popToRootViewController(animated: true)
        
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
