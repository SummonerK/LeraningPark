//
//  AppDelegate.swift
//  BGMediaPlayer
//
//  Created by Luofei on 2018/10/12.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import CoreData

import AVFoundation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //播放器对象
    var audioPlayer: AVAudioPlayer?
    var comBadge:Int = 0
    var isBackground:Bool = false;//标志是否在后台运行
    
    var backgroundTask:UIBackgroundTaskIdentifier! = nil//后台任务标志
    
    func addPlayerToAVPlayerLayer() -> Void {
        //获取本地视频资源
        guard let path = Bundle.main.path(forResource: "xmj.mp3", ofType: nil) else {
            return
        }
        
        let pathURL=NSURL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pathURL as URL)
        } catch {
            audioPlayer = nil
        }
        
        audioPlayer?.setVolume(1.0, fadeDuration: 0.8)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.prepareToPlay()
        
        audioPlayer?.play()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let session = AVAudioSession.sharedInstance()
        
        do{
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }catch{
            print("normal")
        }
        
        if #available(iOS 10.0, *) {
            // iOS 10
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                if success{
                    print("获取权限成功")
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.onMessageReceived(_:)), name: NSNotification.Name(rawValue: BGNMNoticeName), object: nil)
                    
                }else{
                    print("获取权限失败")
                }
            }
            
        }else{
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        return true
    }
    
    func onMessageReceived(_ notifation :NSNotification) {
        
        comBadge += 1
        let content = UNMutableNotificationContent()
        content.title = "我是通知"
        content.body = "今天的你比昨天又有不同之处"
        
        UIApplication.shared.applicationIconBadgeNumber = comBadge
        
        content.sound = UNNotificationSound.default() //设置默认的三全声
        let tigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.4, repeats: false)
        let request = UNNotificationRequest(identifier: "FMTestdev", content: content, trigger: tigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil{
                let timeRemaining = UIApplication.shared.backgroundTimeRemaining;
                NSLog("Background Time Remaining = %.0f Seconds",timeRemaining);//显示系统允许程序后台在线时间
            }
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //注册后台任务
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
        
        isBackground = true
        
        addPlayerToAVPlayerLayer()
        
        BGNM.setRunTimer()
        
//        var theadCount = 0//循环计数器，这里用作时间计数
//        
//        while isBackground {
//            Thread.sleep(forTimeInterval: 1);//休眠
//            theadCount+=1
//            if(theadCount > 9)//每30秒启动一次定位刷新后台在线时间
//            {
//                self.showNotice()
//                
//                let timeRemaining = UIApplication.shared.backgroundTimeRemaining;
//                NSLog("Background Time Remaining = %.02f Seconds",timeRemaining);//显示系统允许程序后台在线时间，如果保持后台成功，这里后台时间会被刷新为180s
//                theadCount=0;
//            }
//            
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
//                print("Time Interval Notification scheduled: \\\\(requestIdentifier)")
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        isBackground = false
        
        audioPlayer?.stop()
        
        audioPlayer = nil
        
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
        let container = NSPersistentContainer(name: "BGMediaPlayer")
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

