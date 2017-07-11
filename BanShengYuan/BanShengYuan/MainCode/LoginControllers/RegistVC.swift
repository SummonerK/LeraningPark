//
//  RegistVC.swift
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

class RegistVC: UIViewController,UITextFieldDelegate{
    
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    let model = ModelVCodePost()
    let modelregest = ModelRegisterPost()
    
    @IBOutlet weak var bton_register: UIButton!
    @IBOutlet weak var bton_getVcode: UIButton!
    
    @IBOutlet weak var tf_phone: UITextField!
    
    @IBOutlet weak var tf_vCode: UITextField!
    
    @IBOutlet weak var tf_fistPwd: UITextField!
    
    @IBOutlet weak var tf_againPwd: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        setRadiusFor(toview: bton_register, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_getVcode, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true
        
        tf_phone.text = USERM.Phone
        model.partnerId = PartNerID
        modelregest.partnerId = PartNerID
        
//        tf_vCode.text = "1592"
//        tf_fistPwd.text = "qwer1234"

    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        
//        "12".doubleValue
        self.navigationItem.title = "注册"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let duration = 0.3

    @IBAction func RegistedAction(_ sender: Any) {
        
        if let str = tf_phone.text , str.isFullTelNumber(){
            modelregest.phone = str
        }else{
            HUDShowMsgQuick(msg: "手机号不合法", toView: KeyWindow, time: 0.8)
            return
        }
        
        if let str = tf_vCode.text , str != ""{
            modelregest.smsCode = str
        }else{
            HUDShowMsgQuick(msg: "验证码不能为空", toView: KeyWindow, time: 0.8)
            return
        }
        
        if let strP = tf_fistPwd.text ,strP.isPwd{
            
//            HUDShowMsgQuick(msg: "密码合法", toView: KeyWindow, time: 0.8)
            
            bton_getVcode.isEnabled = false

            modelregest.password = strP

            VM.loginRegister(amodel: modelregest)
                .subscribe(onNext: { (common:ModelCommonBack) in
                    HUDShowMsgQuick(msg: common.msg!, toView: KeyWindow, time: 0.8)
                    self.navigationController?.popToRootViewController(animated: true)
                },onError:{error in
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
        }else{
            HUDShowMsgQuick(msg: "建议密码为6-20位字母和数字", toView: KeyWindow, time: 0.8)
        }
        
    }
    
    @IBAction func getVCode(_ sender: Any) {
        
        if let str = tf_phone.text , str.isFullTelNumber(){
            
            bton_getVcode.isEnabled = false
            
            model.phone = str
            
            VM.loginGetVCode(amodel: model)
                .subscribe(onNext: { (common:ModelCommonBack) in
                    
                    HUDShowMsgQuick(msg: common.msg!, toView: KeyWindow, time: 0.8)
                    self.setRunTimer()
                    
                },onError:{error in
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
        }else{
            HUDShowMsgQuick(msg: "手机号不合法", toView: KeyWindow, time: 0.8)
        }
        
        
    }
    
    var rtcount: TimeInterval = 60
    var rtimer:Timer?
    
    func setRunTimer(){
        bton_getVcode.isEnabled = false
        bton_getVcode.backgroundColor = FlatGrayDark
        bton_getVcode.setTitleColor(UIColor.white, for: UIControlState.disabled)
        
        if rtimer != nil {
            rtcount = 60
        }else{
            rtimer = Timer.init(fireAt: NSDate() as Date, interval: 1.0, target: self, selector: #selector(rtpick), userInfo: nil, repeats: true)
            
            RunLoop.current.add(rtimer!, forMode:RunLoopMode.commonModes)
        }
    }
    
    func rtpick() {
        PrintFM("\(rtcount)")
        
        if rtcount<=0 {
            rtimer?.invalidate()
            rtimer = nil
            bton_getVcode.setTitle("重新发送", for: UIControlState.normal)
            rtcount = 60
            bton_getVcode.isEnabled = true
        }else{
            bton_getVcode.titleLabel?.text = "\(Int(rtcount))s"
            bton_getVcode.setTitle("\(Int(rtcount))s", for: UIControlState.disabled)
            rtcount -= 1
        }

    }
    
    //MARK:-TextFieldDelegate 输入判断
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        //        PrintFM(string)
        
        if textField == tf_phone , let str = textField.text{
            
            let strLength = str.length - range.length  + string.length
            
            if strLength > 11 {
                return false
            }else if strLength==4 || strLength==5{
                
                PrintFM("\(String(describing: str)) is \(str.isTelNumber())")
                
                return str.isTelNumber()
            }
            
        }
        
        if textField == tf_fistPwd , let str = textField.text{
            
            let strLength = str.length - range.length  + string.length
            
            if strLength > 20{
                return false
            }
        }
        
        return true
        
    }

}

