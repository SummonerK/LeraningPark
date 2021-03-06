//
//  AppDelegate.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift


let WXAPID = "wxbb3b00c8bc6afb6f"

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
//        window?.rootViewController = StoryBoard_Login.instantiateInitialViewController()
//        window?.makeKeyAndVisible()
//        if USERM.MemberID != ""{
//          USERM.setMemberID(uid: "")
            window?.rootViewController = StoryBoard_Main.instantiateInitialViewController()
            window?.makeKeyAndVisible()
//        }else{
//            window?.rootViewController = StoryBoard_Login.instantiateInitialViewController()
//            window?.makeKeyAndVisible()
//        }
        
        //MARK: 设置键盘
        //键盘监听开关
        IQKeyboardManager.sharedManager().enable = false
        //键盘顶部导航
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        //键盘顶部与输入栏底部距离
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 66
        //点击背景 关闭键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        WXApi.registerApp(WXAPID)
        
//        PgyManager.shared().start(withAppId: "ba5d8ec53a4cba8e019ddf51af331a34")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.host == "safepay" {
        
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result) in
                if let resulttemp = result{
                    if let status = resulttemp["resultStatus"]{
                        if (status as! String) == "9000"{
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "ALorderNotifation"), object: nil)
                        }else{
                            HUDShowMsgQuick(msg: "支付失败", toView: KeyWindow, time: 0.8)
                        }
                        
                    }
                }
                
            })
        
        }
        
        if url.host == "pay" {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    //MARK:-微信支付结果
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0 :
                NotificationCenter.default.post(name: Notification.Name(rawValue: "WXorderNotifation"), object: nil)
            case -1 :
                HUDtextShow(toview: KeyWindow, msg: "支付失败", subMsg: resp.errStr)
            case -2 :
                HUDShowMsgQuick(msg: "取消支付", toView: KeyWindow, time: 0.8)
            default:
                HUDtextShow(toview: KeyWindow, msg: "支付失败", subMsg: resp.errStr)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BanShengYuan")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

