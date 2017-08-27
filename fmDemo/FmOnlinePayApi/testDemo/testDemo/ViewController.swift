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
            bton_msg.setTitle(String(describing: error), for: .normal)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

