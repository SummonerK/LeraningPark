//
//  ViewController.swift
//  MY
//
//  Created by Luofei on 2017/6/5.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import PermissionScope

import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    let pscope = PermissionScope()
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up permissions
//        pscope.addPermission(ContactsPermission(),
//                             message: "使用期间需要访问你的通讯录")
//        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
//                             message: "是否允许对你推送消息")
//        pscope.addPermission(LocationWhileInUsePermission(),
//                             message: "使用期间需要访问你的位置")
//        
//        // Show dialog with callbacks
//        pscope.show({ finished, results in
//            print("got results \(results)")
//        }, cancelled: { (results) -> Void in
//            print("thing was cancelled")
//        })
//        locationManager.delegate = self
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        if(CLLocationManager.authorizationStatus() != .denied) {
//            print("应用拥有定位权限")
//        }else {
//            
//            let aleat = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许xxx使用定位服务", preferredStyle: .alert)
//            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
//            }
//            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
//                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
//                if(UIApplication.shared.canOpenURL(url! as URL)) {
//                    UIApplication.shared.openURL(url! as URL)
//                }
//            }
//            aleat.addAction(tempAction)
//            aleat.addAction(callAction)
//            self.present(aleat, animated: true, completion: nil)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

