//
//  AppDelegate.swift
//  bgRefreshNotice
//
//  Created by Luofei on 2018/10/10.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{
    
    var comBadge:Int = 0

    var window: UIWindow?

    var locationManager : CLLocationManager?//定位服务
    var isBackground:Bool = false;//标志是否在后台运行
    var backgroundTask:UIBackgroundTaskIdentifier! = nil//后台任务标志

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager=CLLocationManager()
        locationManager?.delegate=self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.requestAlwaysAuthorization()
        
        if #available(iOS 10.0, *) {
            // iOS 10
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                if success{
                    print("获取权限成功")
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.onMessageReceived(_:)), name: NSNotification.Name(rawValue: BGNMNoticeName), object: nil)
                    
                    //                application.registerForRemoteNotifications(matching: .badge)
                }
                else{
                    print("获取权限失败")
                }
            }

            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        return true
    }
    
    func BackgroundKeepTimeTask()
    {
        debugPrint("进入后台进程");
        
        DispatchQueue.global(qos: .default).async { 
            self.locationManager?.distanceFilter = kCLDistanceFilterNone;//任何运动均接受
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters;//定位精度设置为最差（减少耗电）
            var theadCount = 0;//循环计数器，这里用作时间计数
            var isShowNotice = false;//是否显示掉线通知
            while(self.isBackground)
            {
                Thread.sleep(forTimeInterval: 1);//休眠
                theadCount+=1;
                if(theadCount > 10)//每30秒启动一次定位刷新后台在线时间
                {
                    self.showNotice()
                    debugPrint("开始位置服务");
                    self.locationManager?.startUpdatingLocation();
                    Thread.sleep(forTimeInterval: 1);//定位休眠1秒
                    
                    theadCount=0;
                }
                let timeRemaining = UIApplication.shared.backgroundTimeRemaining;
                NSLog("Background Time Remaining = %.02f Seconds",timeRemaining);//显示系统允许程序后台在线时间，如果保持后台成功，这里后台时间会被刷新为180s
//                if(!ISLogined)//未登录或者掉线状态下关闭后台
//                {
//                    return;//退出循环
//                }
                if(timeRemaining < 60 && !isShowNotice)
                {
//                    self.showNotice()
                    isShowNotice=true;
                }
                
                
            }
            
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        debugPrint("停止位置服务")
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        
        switch (status) {
        case CLAuthorizationStatus.authorizedAlways:
            break;
        case CLAuthorizationStatus.authorizedWhenInUse:
            break;
        case CLAuthorizationStatus.denied:
            break;
        case CLAuthorizationStatus.notDetermined:
            break;
        case CLAuthorizationStatus.restricted:
            break;
        default:
            break;
        }
    }
    
    //定位失败或无权限将会回调这个方法
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        debugPrint("停止位置服务")
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        
        let errors = error as! NSError
        
        if(Int32(errors.code) == CLAuthorizationStatus.denied.rawValue)
        {
            print("未获取到定位权限");
        }
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("位置改变，做点儿事情来更新后台时间");
        let loc = locations.last;
        let latitudeMe = loc?.coordinate.latitude;
        let longitudeMe = loc?.coordinate.longitude;
        debugPrint("\(latitudeMe)");
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        NSLog("进入方位测定");
        //[NSThread sleepForTimeInterval:1];
        let oldRad =  -manager.heading!.trueHeading * M_PI / 180.0;
        let newRad =  -newHeading.trueHeading * M_PI / 180.0;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        self.isBackground = false;
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    //程序进入后台处理
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("background")
        
//        if(CLLocationManager.authorizationStatus() != .denied) {
//            print("应用拥有定位权限")
//            USERM.getLocation { (alocation) in
//                PrintFM("编码成功")
//            }
//        }else {
//            
//        }
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil{
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }else{
            //注册后台任务
            self.backgroundTask = application.beginBackgroundTask(expirationHandler: { 
                () -> Void in
                //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            })
            
            self.isBackground = true
            BackgroundKeepTimeTask()
        }
        
        
    }
    
    func onMessageReceived(_ notifation :NSNotification) {
        
//        let auto = arc4random_uniform(10)
        
//        let auto = comBadge%10
        comBadge += 1
//        if auto == 0{
            let content = UNMutableNotificationContent()
            content.title = "我是通知"
            content.body = "今天的你比昨天又有不同之处"
//            content.badge = NSNumber.init(value: comBadge)
            
            UIApplication.shared.applicationIconBadgeNumber = comBadge
            
            content.sound = UNNotificationSound.default() //设置默认的三全声
            let tigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "FMTestdev", content: content, trigger: tigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error == nil{
                    print("Time Interval Notification scheduled: \\\\(requestIdentifier)")
                }
            }
            
            
//        }

    }
    
    func showNotice() -> Void {
        
        comBadge += 1
        let content = UNMutableNotificationContent()
        content.title = "我是通知"
        content.body = "今天的你比昨天又有不同之处"
//            content.badge = NSNumber.init(value: comBadge)
        
        UIApplication.shared.applicationIconBadgeNumber = comBadge
        
        content.sound = UNNotificationSound.default() //设置默认的三全声
        let tigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FMTestdev", content: content, trigger: tigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil{
                print("Time Interval Notification scheduled: \\\\(requestIdentifier)")
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BGNMNoticeName), object: nil)
        
        USERM.stopUpdatingLocation()
        
        comBadge = 0        
        UIApplication.shared.applicationIconBadgeNumber = comBadge
        
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
        let container = NSPersistentContainer(name: "bgRefreshNotice")
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

