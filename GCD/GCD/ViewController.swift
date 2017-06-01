//
//  ViewController.swift
//  GCD
//
//  Created by luofei on 2017/6/1.
//  Copyright © 2017年 luofei. All rights reserved.
//

import UIKit

//封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("☆☆【☆】\(fileName)\t【☆】ATLine:\(line)\t【☆】\(function)\n【☆】LOG:\(message)")
    #endif
}

class ViewController: UIViewController {
    
    @IBOutlet weak var hight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SerialDis()
//        GetQueue()
//        checkAttributes()
//        checkFMWorkItem()
        fmGroup()
        
        
        
    }
    
    //Dispatch Queue 执行队列
    //Serial 顺序队列
    
    func SerialDis(){
        
        let myQueue: DispatchQueue = DispatchQueue(label: "com.shunxu")
        
        myQueue.sync {
            
            for i in 0...9{
                PrintFM("执行A \(i)")
            }

        }
        
        for i in 0...9{
            PrintFM("执行B \(i)")
        }
        
    }

    //队列和任务优先级
    func GetQueue(){
        
        let queue1 = DispatchQueue(label: "com.appcoda.queue1",qos: DispatchQoS.userInitiated)
//        let queue2 = DispatchQueue(label: "com.appcoda.queue2",qos: DispatchQoS.userInitiated)
        
        let queue2 = DispatchQueue(label: "com.appcoda.queue2",qos: DispatchQoS.utility)
        
        queue1.async {
            
            for i in 0...9{
                PrintFM("执行A \(i)")
            }
        }
        queue2.async {
            
            for i in 0...9{
                PrintFM("执行B \(i)")
            }
        }
        
        for i in 0...9{
            PrintFM("执行C \(i)")
        }
        
        
    }
    
    
    //并发队列
    func checkAttributes(){
//        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue",qos: .utility)
        //任务被顺序执行
        let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue",qos: .utility,attributes:.concurrent)
        //这个队列所有的任务将被同时执行，任务将被高度并发执行
        
        anotherQueue.async {
            for i in 0...9{
                PrintFM("执行a \(i)")
            }
        }
        anotherQueue.async {
            for i in 0...9{
                PrintFM("执行b \(i)")
            }
        }
        anotherQueue.async {
            for i in 0...9{
                PrintFM("执行c \(i)")
            }
        }
    }
    
    //获取队列 两种类型
    //Main Dispatch Queue : 主队列 需要更新UI时我们才获取
    //Global Dispatch Queue 全局队列 其他情况
    
    func checkFMQueue(){
        let globalQueue = DispatchQueue.global()
        
        let globalQueue1 = DispatchQueue.global(qos: .userInitiated)
        //使用全局变量，你只能使用部分属性，例如服务等级(Qos class)
        
        //需要更新UI
        DispatchQueue.main.async {
            //更新UI
        }
        
        //eg:
        
//        if let data = imageData {
//            print("Did download image data")
//        耗时操作，或者下载任务完成时
//        更新UI
//
//            Dispatchqueue.main.async {
//                self.imageView.image = UIImage(data: data)
//            }
//        }
        
    }
    
    //DispatchWorkItem对象
    //DispatchWorkItem 是一个代码块，它可以被分到任何的队列，包含的代码可以在后台或主线程中被执行，简单来说:它被用于替换我们前面写的代码block来调用
    func checkFMWorkItem(){
        //简单使用
//        let workItem = DispatchWorkItem {
//            // Do something
//        }
        
        var value = 10
        
        PrintFM("value = \(value)")
        
        let workItem1 = DispatchWorkItem {
            value += 5
            PrintFM("value = \(value)")
        }
        
        //workItem1 用于让Value每次递增5 ，通过Perform（）来激活
        
        workItem1.perform() //默认将会在主线程执行， 也可以在其他队列中执行
        let queue = DispatchQueue.global()
        
//        queue.async {
//            workItem1.perform()
//        }
//        
        queue.async(execute:workItem1) //更简洁实现，一样正常运行
        
        //当一个WorkItem被分发，你可以通知主队列(或其他队列)来做一些后续的处理:
        workItem1.notify(queue: queue) { 
            PrintFM("value = \(value)")
        }
        
    }
    
    //
    
    func fmGroup() {
        let globalQ = DispatchQueue.global(qos:.default)
        let group = DispatchGroup()
        globalQ.async(group: group, execute: {
            PrintFM("Q1")
        })
        globalQ.async(group: group, execute: {
            PrintFM("Q2")
        })
        globalQ.async(group: group, execute: {
            PrintFM("Q3")
        })
        
//        group.notify(queue: globalQ) { 
//            PrintFM("完成")
//        }
//        group.wait(timeout: DispatchTime(uptimeNanoseconds: 10*NSEC_PER_SEC))
        
        PrintFM("completed")
        
        
        //需要注意的是，dispatch_group_wait实际上会使当前的线程处于等待的状态，也就是说如果是在主线程执行dispatch_group_wait，在上面的Block执行完之前，主线程会处于卡死的状态。可以注意到dispatch_group_wait的第二个参数是指定超时的时间，如果指定为DISPATCH_TIME_FOREVER（如上面这个例子）则表示会永久等待，直到上面的Block全部执行完，除此之外，还可以指定为具体的等待时间，根据dispatch_group_wait的返回值来判断是上面block执行完了还是等待超时了。
    }
    
    //barrier_async 写文件只是在NSUserDefaults写入一个数字7，读只是将这个数字打印出来而已。我们要避免在写文件时候正好有线程来读取，就使用dispatch_barrier_async函数
    
    func barrier() {
        let userD = UserDefaults.standard
        userD.set("1", forKey: "name")
        
        let globalQ = DispatchQueue.global()
        globalQ.sync {
            PrintFM("\(readInfo())")
        }
        globalQ.sync {
            PrintFM("\(readInfo())")
        }
        globalQ.sync {
            PrintFM("\(readInfo())")
        }
        
        globalQ.sync {
            PrintFM("\(readInfo())")
        }
        globalQ.sync {
            PrintFM("\(readInfo())")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 保存，或修改
    func saveInfo(name:String)
    {
        if (0 <= name.characters.count)
        {
            let userDefault = UserDefaults.standard
            userDefault.set("Luffy", forKey: "name")
            userDefault.synchronize()
           
        }
    }
 
    // 读取
    func readInfo() -> String
    {
        let userDefault = UserDefaults.standard
        let name = userDefault.object(forKey: "name") as? String
        
        if (name != nil)
        {
            return name!
        }
        
        return ""
    }


}

