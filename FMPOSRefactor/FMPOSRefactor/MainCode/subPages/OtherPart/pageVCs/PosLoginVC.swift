//
//  PosLoginVC.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/22.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class PosLoginVC: UIViewController {
    
    @IBOutlet weak var tf_user: UITextField!    ///输入用户名
    @IBOutlet weak var tf_pwd: UITextField!     ///输入密码
    @IBOutlet weak var tf_stationId: UITextField!   ///输入门店号
    @IBOutlet weak var tf_partnerId: UITextField!   ///输入商户号
    @IBOutlet weak var label_versionIPhone: UILabel!  ///填入版本信息
    @IBOutlet weak var label_versionIPad: UILabel!    ///填入版本信息
    
    @IBOutlet weak var bton_login: UIButton!    ///登录按钮
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IBLDeviceIPad{
            label_versionIPad.text = "非码网络科技有限公司提供技术支持 版本号v" + UIDevice.current.IBLVersion
        }else{
            label_versionIPhone.text = "版本号v" + UIDevice.current.IBLVersion
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Action Part
    
    ///登陆操作响应
    @IBAction func actionLogin(_ sender: Any) {
        
        bton_login.IBLViewShakeShake(.horizontal)
        
    }

    ///返回操作响应
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
