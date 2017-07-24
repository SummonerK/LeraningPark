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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        setPageValue()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(action(notification:)), name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
    }
    
    //通知内容接收
    func action(notification: NSNotification) {
        
        PrintFM("微信支付成功")
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionWXPay(_ sender: Any) {
        
        HUDShowMsgQuick(msg: "微信支付尚未开放", toView: KeyWindow, time: 0.8)
        return
        
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
        
        
//            let biz_content = "app_id=2017071207729556&biz_content=%7b%22out_trade_no%22%3a%22SHT1A1553O1336740803%22%2c%22seller_id%22%3a%22%22%2c%22total_amount%22%3a%220.01%22%2c%22subject%22%3a%22%e5%8d%8a%e7%94%9f%e7%bc%98%22%2c%22goods_detail%22%3a%5b%7b%22goods_id%22%3a%221323%22%2c%22goods_name%22%3a%22%e6%9c%aa%e7%9f%a5%e5%95%86%e5%93%81%22%2c%22quantity%22%3a%221%22%2c%22price%22%3a%2299%22%7d%5d%2c%22store_id%22%3a%22107%22%7d&charset=utf-8&method=alipay.trade.app.pay&notify_url=http%3a%2f%2f115.159.142.32%2fapi%2falipaynotify%2f1553&prod_code=QUICK_MSECURITY_PAY&sign_type=RSA&timestamp=2017-07-14+09%3a39%3a12&version=1.0&sign=NUAMMvKtQdZj8Qrdl3wRqjoFgHk5gq8UlxH4o92Qn3FuO2cyunkve3wY5EbrAvuzvc1X4p5APlRKCnmat1rmzpxREsnTKxawL8HlQs4KESk4CIaRUJkyHnATuLCGbwagcHXuJnL8Pun4sY9hx4SAjmM6O7U%2faFi1Z9nrHJC6Rlc%3d"
//
//            AlipaySDK.defaultService().payOrder(biz_content, fromScheme: "bsy", callback: {(result) in
//
//                //            HUDShowMsgQuick(msg: String(describing: result?.description), toView: self.view, time: 0.8)
//
//                print("---\(String(describing: result?.description))")
//            })
        
        if let oid = self.orderID{
            
            modelpayPost.orderId = "\(oid)"
            
        }
    
        
        OrderM.orderPay(amodel: modelpayPost)
            
            .subscribe(onNext: { (posts: modelPayPlanBack) in

                PrintFM("pictureList\(posts)")

                if let content = posts.data{

                    PrintFM("content = \(content)")
                    
                    //支付宝支付
                    if self.payChanel == 1{
                        
                        AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsy", callback: {(result) in
                            
                            if let resulttemp = result{
                                if let status = resulttemp["resultStatus"]{
                                    PrintFM(status)
                                    
                                    var str = String()
                                    
                                    if (status as! String) == "9000"{
                                        str = "支付成功"
                                    }else if (status as! String) == "8000"{
                                        str = "支付确认中"
                                    }else{
                                        str = "支付失败"
                                    }
                                    
                                    HUDShowMsgQuick(msg: str, toView: self.view, time: 0.8)
                                    
                                }
                            }
                            
                            print("---\(String(describing: result?.description))")
                        })
                    }

                    //支付宝支付
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
