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

    @IBOutlet weak var tf_amount: UITextField!
    
    var trueAmount:Int = 0 //真实金额, Int 数据类型, 单位（分）
    
    var _tapGesture: UITapGestureRecognizer! //手势
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        self.view.addGestureRecognizer(_tapGesture)
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
        
        tf_amount.text = tf_amount.text?.fixAmount()
    }
    
    
//MARK:-调取支付操作
    
    @IBAction func action_aliPay(_ sender: Any) {
        setModelWith(type: 1)
    }
    
    
    @IBAction func action_wxPay(_ sender: Any) {
        setModelWith(type: 2)
    }
    
    
    func setModelWith(type:Int) {
        model.partnerId = 1447
        model.transAmount = 1
        model.paymentMethodCode = type == 1 ? "20002":"20001"
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
        
        print("\(model.toDictionary())")
        
        manager?.fmCreatPay(model, andScheme: "fmsdk", successBlock: { (result) in
            print("%@",result ?? NSDictionary())
        }) { (error) in
            print("\(String(describing: error))")
        }
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

