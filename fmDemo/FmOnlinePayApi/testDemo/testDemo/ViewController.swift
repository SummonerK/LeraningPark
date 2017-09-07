//
//  ViewController.swift
//  testDemo
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = NetHelper.sharedInstance()
    let model = FmPrepayModel()

    @IBOutlet weak var bton_msg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func pay(_ sender: Any) {
        
        setModelWith(type: 2)
    }
    
    func setModelWith(type:Int) {
        
        var payType = ""
        var schemeStr = ""
        if type == 1 {
            payType = "20002"
            schemeStr = "fmsdk"
        }else if type == 2 {
            payType = "20001"
        }else if type == 3 {
            payType = "20003"
            schemeStr = "FmUPPaySdk"
        }
        
        model.partnerId = 1447
        model.transAmount = 1
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
        
        manager?.fmCreatPay(model, andScheme: schemeStr, andMode: "01", andViewController: self, successBlock: { (Result) in
            print("Result \(String(describing: Result?.toDictionary()))");
            self.bton_msg.setTitle(Result?.resultMsg, for: .normal)
        }, failureBlock: { (EResult) in
            print("error \(String(describing: EResult?.toDictionary()))");
            self.bton_msg.setTitle(EResult?.resultMsg, for: .normal)
        })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

