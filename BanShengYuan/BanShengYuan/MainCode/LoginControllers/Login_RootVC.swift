//
//  Login_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import IQKeyboardManagerSwift

import RxSwift
import ObjectMapper
import SwiftyJSON

class Login_RootVC: UIViewController{
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var bton_login: UIButton!
    @IBOutlet weak var bton_register: UIButton!
    @IBOutlet weak var bton_forget: UIButton!
    
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    let model = ModelLoginPost()
    let model_info = ModelUserGetInfoPost()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let result:[AnyHashable:Any] = [AnyHashable("resultStatus"): 9000, AnyHashable("result"): "11" ,AnyHashable("memo"): ""]
        PrintFM("result\(result["resultStatus"]!)")
        
        let status:Int = result["resultStatus"] as! Int
        
        PrintFM("status = \(status)")
        
        let str = "48000"
        
        PrintFM("price = \(str.fixPrice())")
        
        setNavi()
        
        tf_phone.attributedPlaceholder = NSAttributedString(string:"请输入手机号",attributes:[NSForegroundColorAttributeName: UIColor.white])
        tf_pwd.attributedPlaceholder = NSAttributedString(string:"请输入密码",attributes:[NSForegroundColorAttributeName: UIColor.white])
        
        setRadiusFor(toview: bton_login, radius: 6, lineWidth: 0, lineColor: UIColor.clear)
        setRadiusFor(toview: bton_register, radius: 6, lineWidth: 0.6, lineColor: UIColor.white)
        
//        let attributestr = NSMutableAttributedString(string: "忘记密码", attributes: setUnderLineToString(tocolor: FlatGrayLight))
//        
//        bton_forget.setAttributedTitle(attributestr, for: UIControlState.normal)
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = true

        ShowWelecomeV()
        
        tf_phone.text = USERM.Phone
        model.partnerId = PARTNERID
        tf_pwd.text = USERM.Pwd
        
        
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
            
            let array : Array<UIImage> = [BundleImageWithName("guide1")!,BundleImageWithName("guide2")!,BundleImageWithName("guide3")!]
            
            return array
        }
//        welecomeV.titles = {
//            return ["文章分类,方便阅读","纯黑设计,极客最爱","代码高亮,尊重技术","一键分享,保留精彩"]
//        }
        
        welecomeV.contentSize = {
            return CGSize.init(width: IBScreenWidth, height: IBScreenHeight)
        }
        
        welecomeV.doneButton = {
            let button : UIButton = UIButton(frame:CGRect.init(x: welecomeV.frame.size.width * 0.1, y: welecomeV.frame.size.height - 50, width: welecomeV.frame.size.width * 0.8, height: 33))
            button.setImage(BundlePngWithName("button_start")!, for:UIControlState.normal)
            return button
        }
        
        welecomeV.showGuideView()
        
    }
    
    let duration = 0.3
    
    @IBAction func loginAction(_ sender: Any) {
        PrintFM("登录")
        model.phone = tf_phone.text
        model.password = tf_pwd.text
        
//        
//        if model.password.isPwd {
//            HUDShowMsgQuick(msg: "safe", toView: self.view, time: 0.8)
//        }else{
//            HUDShowMsgQuick(msg: "not safe", toView: self.view, time: 0.8)
//        }
        
        VM.loginLogin(amodel: model)
            .subscribe(onNext: { (common:ModelCommonBack) in
                PrintFM("登录\(String(describing: common.description))")
                
                USERM.setPhone(phone: self.model.phone)
                USERM.setPwd(pwd: self.model.password)
                USERM.setUserID(uid: "userID")
                
                
                self.getInfoData()
                
            },onError:{error in
                
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }

            })
            .addDisposableTo(disposeBag)
        
        
//        KeyWindow.rootViewController = StoryBoard_Main.instantiateInitialViewController()
//        
//        let animation = CATransition.init()
//        animation.duration = duration
//        animation.type = kCATransitionFade
//        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
        
    }
    
    @IBAction func goToRegist(_ sender: Any) {
 
    }
    
    @IBAction func goToReSetting(_ sender: Any) {
        
    }
    
    //获取个人信息
    
    func getInfoData(){
        
        model_info.partnerId = PARTNERID
        model_info.phone = USERM.Phone
        
        VM.userGetInfo(amodel: model_info)
            .subscribe(onNext: { (posts: ModelUserInfoBack) in
                
                PrintFM("\(posts.description)")

                if let memberid = posts.memberId{
                    
                    USERM.setMemberID(uid: memberid)
                    
                    KeyWindow.rootViewController = StoryBoard_Main.instantiateInitialViewController()
                    let animation = CATransition.init()
                    animation.duration = self.duration
                    animation.type = kCATransitionFade
                    UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
                    
                }

            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
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

