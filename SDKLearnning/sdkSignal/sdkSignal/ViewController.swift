//
//  ViewController.swift
//  sdkSignal
//
//  Created by Luofei on 2017/8/23.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import FmOnlinePayApi

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func TestingAction(_ sender: Any) {
        Manager.createPay(prams: ["颜色":"橘色"]) { (back) in
            print("back = \(back)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

