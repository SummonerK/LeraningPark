//
//  ViewController.swift
//  bgRefreshNotice
//
//  Created by Luofei on 2018/10/10.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var label_msg: UILabel!
    
    var comBadge:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(CLLocationManager.authorizationStatus() != .denied) {
//            print("应用拥有定位权限")
//            USERM.getLocation { (alocation) in
//                PrintFM("编码成功")
//            }
//        }else {
//            
//        }
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.onMessageReceived(_:)), name: NSNotification.Name(rawValue: BGNMNoticeName), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func beginBGSend(_ sender: Any) {
        
//        BGNM.setRunTimer()
        //关闭后台轮询调取releasepick()  //或者强制杀死程序。
//        BGNM.releasepick()
        
        self.SWGoNextVC("WMLogPageVC", .swPresent, [:], { (back) in
            print("\(back)")
        })
        
    }
    
    func onMessageReceived(_ notifation :NSNotification) {
        
        comBadge += 1
        
        label_msg.text = comBadge.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

