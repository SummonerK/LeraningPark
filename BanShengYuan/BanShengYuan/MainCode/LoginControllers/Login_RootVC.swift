//
//  Login_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import IQKeyboardManagerSwift

class Login_RootVC: UIViewController{
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var bton_login: UIButton!
    @IBOutlet weak var bton_register: UIButton!
    @IBOutlet weak var bton_forget: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        setRadiusFor(toview: bton_login, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_register, radius: 6, lineWidth: 0.6, lineColor: FlatGrayDark)
        let attributestr = NSMutableAttributedString(string: "忘记密码", attributes: setUnderLineToString(tocolor: FlatGrayLight))
        bton_forget.setAttributedTitle(attributestr, for: UIControlState.normal)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true

        ShowWelecomeV()
        
    }
    
    func setNavi() {
        self.navigationItem.title = "账号登录"
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
    
    let duration = 0.3
    
    @IBAction func loginAction(_ sender: Any) {
        PrintFM("登录")
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let storyboard_HOME = UIStoryboard.init(name: "Main", bundle: nil)
        window?.rootViewController = storyboard_HOME.instantiateInitialViewController()
        
        let animation = CATransition.init()
        animation.duration = duration
//        animation.type = "rippleEffect" //波纹
        animation.type = kCATransitionFade 
        
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
    }
    @IBAction func goToRegist(_ sender: Any) {
        
//        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistVC") as! RegistVC
//        
//        self.present(Vc, animated: false, completion: nil)
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        //        animation.type = "rippleEffect" //波纹
//        animation.type = kCATransitionFade
//        
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
    }
    
    @IBAction func goToReSetting(_ sender: Any) {
//        
//        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "getResetCodeVC") as! getResetCodeVC
//        
//        self.present(Vc, animated: false, completion: nil)
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        //        animation.type = "rippleEffect" //波纹
//        animation.type = kCATransitionFade
//        
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
    }

}

extension Login_RootVC:UITextFieldDelegate{
    
    
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

