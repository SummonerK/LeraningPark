//
//  ViewController.swift
//  fmPaySDKDemo-swift
//
//  Created by Luofei on 2017/8/25.
//  Copyright © 2017年 fmPay. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    let manager = NetHelper.sharedInstance()
    let model = FmPrepayModel()
    
    @IBOutlet weak var tf_storeId: UITextField!
    @IBOutlet weak var tf_amount: UITextField!
    @IBOutlet weak var tv_backContent: UITextView!
    
    var trueAmount:Int = 1 //真实金额, Int 数据类型, 单位（分）
    
    var _tapGesture: UITapGestureRecognizer! //手势
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        self.view.addGestureRecognizer(_tapGesture)
        
        tf_amount.text = "\(trueAmount)"
        tf_storeId.text = "-1"
    }

    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.ended {
            tf_amount.resignFirstResponder()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func setAmount(_ sender: Any) {
        
        tf_amount.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        textField.text = ""
        trueAmount = 0
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField == tf_amount , let str = textField.text{
            
            if str.intValue == 0 {
                
                textField.text = ""
            }
            
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        trueAmount = textField.text?.intValue ?? 0
        
//        tf_amount.text = tf_amount.text?.fixAmount()
    }
    
    
//MARK:-调取支付操作
//    支付宝支付
    @IBAction func action_aliPay(_ sender: Any) {
        setModelWith(type: 1)
    }
//    微信支付
    @IBAction func action_wxPay(_ sender: Any) {
        setModelWith(type: 2)
    }
//    银联支付
    @IBAction func action_unPay(_ sender: Any) {
        setModelWith(type: 3)
    }
    
    func setModelWith(type:Int) {
        
        tf_amount.resignFirstResponder()
        
        if trueAmount == 0{
            tv_backContent.text = "请设置支付金额";
            return
        }
    
        var payType = ""
        var schemeStr = ""
        model.partnerId = 1443
        if type == 1 {///支付宝支付
            payType = "20002"
            schemeStr = "fmalipaysdk"
            model.partnerId = 1447
        }else if type == 2 {///微信支付
            payType = "20001"  
        }else if type == 3 {
            payType = "20003"///银联支付
            schemeStr = "FmUPPaySdk"
        }
        model.storeId = tf_storeId.text
        model.transAmount = Int32(trueAmount)
        model.paymentMethodCode = payType
        model.partnerOrderId = "\(Int(Date().timeIntervalSince1970))"
        var products = [FmPayProductModel]()
        for i in 1...1 {
            let product:FmPayProductModel = FmPayProductModel()
            product.pid = "\(i)"
            product.price = 1
            product.name = "商品\(i)"
            product.consumeNum = 1
            products.append(product)
        }
        model.products = products
        
        let dic = model.toDictionary()
        
        print("\(String(describing: dic?.keys))")
        print("\(String(describing: dic?.values))")
        
        manager?.fmCreatPay(model, andScheme: schemeStr, andViewController: self, successBlock: { (Result) in
            self.tv_backContent.text = Result?.toJSONString()
        }, failureBlock: { (EResult) in
            self.tv_backContent.text = EResult?.toJSONString()
        })
        
    }
}

extension String{
    
    var intValue: Int? {return NumberFormatter().number(from: self)?.intValue}
    var doubleValue: Double? {return NumberFormatter().number(from: self)?.doubleValue}
    
    func fixAmount() -> String {
        
        if self == ""{
            return "0.00"
        }
        
        let formatter = NumberFormatter()
        let value = self.doubleValue
        let format = NSMutableString(string: "###,##0.")
        let precision = 2
        if(precision == 0)
        {
            formatter.positiveFormat = format as String
            return formatter.string(from: NSNumber(value: value!/100))!
        }
        else
        {
            for _ in 1...precision
            {
                format.appendFormat("0")
            }
            formatter.positiveFormat = format as String
            return formatter.string(from: NSNumber(value: value!/100))!
        }
        
    }
    
}

