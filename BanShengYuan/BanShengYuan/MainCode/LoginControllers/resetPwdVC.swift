//
//  resetPwdVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import IQKeyboardManagerSwift

class resetPwdVC: UIViewController {
    
    var model_verify = ModelVCodeVerifyPost()
    
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    let model_newPwd = ModelUpdatePwdPost()

    @IBOutlet weak var tf_fistPwd: UITextField!
    
    @IBOutlet weak var tf_againPwd: UITextField!
    
    @IBOutlet weak var bton_resetPwd: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRadiusFor(toview: bton_resetPwd, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true
        
        setNavi()
        
        model_newPwd.partnerId = model_verify.partnerId
        model_newPwd.phone = model_verify.phone
        model_newPwd.smsCode = model_verify.smsCode
        
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
        
        var FPwd = String()
        
        var APwd = String()
        
        if let strP = tf_fistPwd.text ,strP.pwdisSafe(){
            FPwd = strP
        
        }else{
            HUDShowMsgQuick(msg: "建议密码为6-20位字母和数字", toView: KeyWindow, time: 0.8)
            
            return
        }
        
        if let strP = tf_againPwd.text ,strP.pwdisSafe(),strP != ""{
            APwd = strP
            
        }else{
            HUDShowMsgQuick(msg: "建议密码为6-20位字母和数字", toView: KeyWindow, time: 0.8)
            
            return
        }
        
        
        if FPwd == APwd {
            
            model_newPwd.password = APwd
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }else{
            HUDShowMsgQuick(msg: "密码不一致", toView: KeyWindow, time: 0.8)
            
            return
        }
        
        
        
        VM.loginUpdatePWD(amodel: model_newPwd)
            .subscribe(onNext: { (common:ModelCommonBack) in
                HUDShowMsgQuick(msg: common.msg!, toView: KeyWindow, time: 0.8)
                //返回登录页
                self.navigationController?.popToRootViewController(animated: true)

            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: KeyWindow, time: 0.8)

                }else{
                    HUDShowMsgQuick(msg: "server error", toView: KeyWindow, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        
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
