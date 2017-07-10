//
//  getResetCodeVC.swift
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

class getResetCodeVC: UIViewController,UITextFieldDelegate{
    
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    let model = ModelVCodePost()

    let model_verify = ModelVCodeVerifyPost()

    @IBOutlet weak var tf_phone: UITextField!
    
    @IBOutlet weak var tf_vCode: UITextField!
    
    @IBOutlet weak var bton_getVCode: UIButton!
    
    @IBOutlet weak var bton_goNext: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setRadiusFor(toview: bton_goNext, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_getVCode, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true
        
        tf_phone.text = USERM.Phone
//        tf_vCode.text = "7292"
        model.partnerId = PartNerID
        model_verify.partnerId = PartNerID
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    let duration = 0.3

    @IBAction func goToResetVC(_ sender: Any) {

        if let str = tf_phone.text , str.isFullTelNumber(){
            model_verify.phone = str
        }else{
            HUDShowMsgQuick(msg: "手机号不合法", toView: KeyWindow, time: 0.8)
            return
        }
        
        if let str = tf_vCode.text , str != ""{
            model_verify.smsCode = str
            
            VM.loginVCodeVerify(amodel: model_verify)
                .subscribe(onNext: { (common:ModelCommonBack) in
                    HUDShowMsgQuick(msg: common.msg!, toView: KeyWindow, time: 0.8)
                    //空中花市
                    let Vc = StoryBoard_Login.instantiateViewController(withIdentifier: "resetPwdVC") as! resetPwdVC
                    Vc.model_verify = self.model_verify
                    self.navigationController?.pushViewController(Vc, animated: true)
                    
                },onError:{error in
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                        
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
        }else{
            HUDShowMsgQuick(msg: "验证码不能为空", toView: KeyWindow, time: 0.8)
            return
        }
        

    }
    
    @IBAction func getVCode(_ sender: Any) {
        
        PrintFM("")
        
//        self.setRunTimer()
        
        
        if let str = tf_phone.text , str.isFullTelNumber(){
            
            bton_getVCode.isEnabled = false
            
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
        bton_getVCode.isEnabled = false
        bton_getVCode.backgroundColor = FlatGrayDark
        bton_getVCode.setTitleColor(UIColor.white, for: UIControlState.disabled)
        
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
            bton_getVCode.setTitle("重新发送", for: UIControlState.normal)
            rtcount = 60
            bton_getVCode.isEnabled = true
        }else{
            bton_getVCode.titleLabel?.text = "\(Int(rtcount))s"
            bton_getVCode.setTitle("\(Int(rtcount))s", for: UIControlState.disabled)
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
        
        return true
        
    }

}

