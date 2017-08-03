//
//  pay_channelVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import MBProgressHUD

//"oid":81610978848932101
//price:23300
class pay_channelVC: UIViewController {
    
    var finalPrice:Int?
    var orderID:Int!
    
    @IBOutlet weak var label_finalPrice: UILabel!
    @IBOutlet weak var imageV_wx: UIImageView!
    @IBOutlet weak var imageV_al: UIImageView!
    var payChanel = 1
    
    //network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    let modelpayPost = ModelOrderPayPost()
    
    let modelAccess = ModelOrderPayAccessPost()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        setPageValue()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(wxaction(notification:)), name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(alaction(notification:)), name: NSNotification.Name(rawValue: "ALorderNotifation"), object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
    }
    
    //通知内容接收
    func wxaction(notification: NSNotification) {
        
        PrintFM("微信支付成功")
        self.payAccess()
        
    }
    
    //通知内容接收
    func alaction(notification: NSNotification) {
        
        PrintFM("支付宝支付成功")
        
        self.payAccess()
        
    }
    
    func setPageValue() {
        
        if let price = finalPrice {
            
            let strPrice = "\(price)"
            
            PrintFM("\(strPrice)")
            
            label_finalPrice.text = String.init("¥ \(String(describing: strPrice.fixPrice()))")
        }
        
        PrintFM("orderID = \(orderID)")
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "支付"
    }
    
    func actionBack(_ sender: Any) {
        
        let alert = UIAlertController(title: "提示", message: "确认离开收银台？", preferredStyle: .alert)
        
        let calcelAction = UIAlertAction(title: "继续支付", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "确认离开", style: .default, handler: { (UIAlertAction) in
            
            //跳转到订单页
            
            //我的订单
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "orderListRootVC") as! orderListRootVC
            self.navigationController?.pushViewController(Vc, animated: true)
            
//            self.navigationController?.popToRootViewController(animated: true)
            
        })
        
        // 添加
        alert.addAction(calcelAction)
        alert.addAction(deleteAction)
        
        // 弹出
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func actionWXPay(_ sender: Any) {
        
//        HUDShowMsgQuick(msg: "微信支付尚未开放", toView: KeyWindow, time: 0.8)
//        return
        
        payChanel = 2
        imageV_wx.image = UIImage.init(named: "choose_s")
        imageV_al.image = UIImage.init(named: "choose_n")
        
        PrintFM("")
    }
    
    @IBAction func actionAliPay(_ sender: Any) {
        payChanel = 1
        imageV_wx.image = UIImage.init(named: "choose_n")
        imageV_al.image = UIImage.init(named: "choose_s")
        
        PrintFM("")
    }
    
    @IBAction func actionPay(_ sender: Any) {
        
        if payChanel == 1{
            modelpayPost.pay_ebcode = aliPay_ebcode
        }else{
            modelpayPost.pay_ebcode = wxPay_ebcode
        }
        
        if let oid = self.orderID{
            
            modelpayPost.orderId = "\(oid)"
            modelAccess.orderId = "\(oid)"
        }
    
        
        OrderM.orderPay(amodel: modelpayPost)
            
            .subscribe(onNext: { (posts: modelPayPlanBack) in

                PrintFM("pictureList\(posts)")

                if let content = posts.data{

                    PrintFM("content = \(content)")
                    
                    //支付宝支付
                    if self.payChanel == 1{
                        
                        AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsyal", callback: {(result) in
                            
                            if let resulttemp = result{
                                if let status = resulttemp["resultStatus"]{
                                    if (status as! String) == "9000"{
                                        
//                                        HUDShowMsgQuick(msg: "支付成功", toView: KeyWindow, time: 0.8)
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ALorderNotifation"), object: nil)
                                        
                                    }else{
                                        HUDShowMsgQuick(msg: "支付失败", toView: KeyWindow, time: 0.8)
                                    }
                                    
                                }
                            }
                            
                        })
                        
                    }

                    //微信支付
                    if self.payChanel == 2{
                        
                        if let wxorder = content.pay_order{
                            
                            let paypost:PayReq = PayReq.init()
                            paypost.openID = wxorder.appid!
                            paypost.partnerId = "\(wxorder.mch_id!)"
                            paypost.prepayId = wxorder.prepay_id!
                            paypost.package = "\(wxorder.package!)"
                            paypost.nonceStr = wxorder.nonce_str!
                            paypost.timeStamp = UInt32(wxorder.timestamp!)!
                            paypost.sign = wxorder.sign!
                            WXApi.send(paypost)
                            
                        }
                        
                    }
                    

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
    
    func payAccess(){
        
//        HUDShowMsgQuick(msg: "ShowPayAccess", toView: self.view, time: 0.8)
        
//        //我的订单
//        let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "orderListRootVC") as! orderListRootVC
//        self.navigationController?.pushViewController(Vc, animated: true)
        
//        self.navigationController?.popToRootViewController(animated: true)
        
        
        OrderM.orderPayAccess(amodel: modelAccess)
            
            .subscribe(onNext: { (posts: ModelOrderPayAccessBack) in
                
                PrintFM("pictureList\(posts)")
                
                if let content = posts.data{
                    
//                    self.navigationController?.popToRootViewController(animated: true)
                    //我的订单
                    let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "orderListRootVC") as! orderListRootVC
                    self.navigationController?.pushViewController(Vc, animated: true)
                    
                    PrintFM("content = \(content)")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
