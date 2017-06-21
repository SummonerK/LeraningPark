//
//  RegistVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RegistVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var bton_register: UIButton!
    @IBOutlet weak var bton_getVcode: UIButton!
    
    @IBOutlet weak var tf_phone: UITextField!
    
    @IBOutlet weak var tf_vCode: UITextField!
    
    @IBOutlet weak var tf_fistPwd: UITextField!
    
    @IBOutlet weak var tf_againPwd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        setRadiusFor(toview: bton_register, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_getVcode, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true

    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
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
        
//        self.dismiss(animated: false, completion: nil)
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        //        animation.type = "rippleEffect" //波纹
//        animation.type = kCATransitionFade 
//        
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func getVCode(_ sender: Any) {
        
        setRunTimer()
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
            bton_getVcode.setTitle("获取验证码", for: UIControlState.normal)
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
        
        return true
        
    }

}

