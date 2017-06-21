//
//  getResetCodeVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift

class getResetCodeVC: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var tf_phone: UITextField!
    
    @IBOutlet weak var tf_vCode: UITextField!
    
    @IBOutlet weak var bton_getVCode: UIButton!
    
    @IBOutlet weak var bton_goNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setRadiusFor(toview: bton_goNext, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_getVCode, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "忘记密码"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let duration = 0.3

    @IBAction func goToResetVC(_ sender: Any) {
//
//        let resetVc = self.storyboard?.instantiateViewController(withIdentifier: "resetPwdVC") as! resetPwdVC
//        
//        self.present(resetVc, animated: false, completion: nil)
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        //        animation.type = "rippleEffect" //波纹
//        animation.type = kCATransitionFade 
//        
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)

    }
    
    @IBAction func getVCode(_ sender: Any) {
        
        setRunTimer()
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
            bton_getVCode.setTitle("获取验证码", for: UIControlState.normal)
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

