//
//  ViewController.swift
//  TimeClock
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
    
    @IBOutlet weak var Hight: NSLayoutConstraint!
    @IBOutlet weak var label_time: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Run(_ sender: Any) {
        
//        runOnetime()
//        runMuchtime()
        setRunTimer()
    }
    
    //延时执行
    //每调一次会执行一次，调用需考虑控制问题，否则会多次调取
    func runOnetime(){
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { 
            self.label_time.text = "延时了2秒执行了"
            PrintFM("延时了2秒执行了")
        }
    }
    
    //执行多次
    //每调一次会执行一次，调用需考虑控制问题，否则会多次调取
    var time: TimeInterval = 10
    var counttime:Timer?
    func runMuchtime(){
        
        //单次执行
        
//        counttime = Timer(timeInterval: 1, target: self, selector: #selector(self.repick), userInfo: nil, repeats: true)
        
        
        if counttime != nil {
            time = 10
        }else{
//            多次执行 1
            
//            counttime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (atimer) in
//                PrintFM("\(self.time)")
//                if self.time<=0 {
//                    atimer.invalidate()
//                    self.counttime = nil
//                    self.label_time.text = "重发"
//                    self.time = 10
//                }else{
//                    
//                    self.label_time.text = "\(self.time)"
//                    self.time -= 1
//                }
//            })
            
//            多次执行 2
            
            counttime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(repick), userInfo: nil, repeats: true)
        }
        
    }
    
    func repick() {
        PrintFM("\(time)")
        if time<=0 {
            counttime?.invalidate()
            counttime = nil
            label_time.text = "重发"
            time = 10
        }else{
            
            label_time.text = "\(time)"
            time -= 1
        }
    }
    
    //Runloop + Timer
    
    var rtcount: TimeInterval = 60
    var rtimer:Timer?
    func setRunTimer(){
        if rtimer != nil {
            rtcount = 60
        }else{
            rtimer = Timer.init(fireAt: NSDate() as Date, interval: 1.0, target: self, selector: #selector(rtpick), userInfo: nil, repeats: true)
            
            RunLoop.current.add(rtimer!, forMode:RunLoopMode.commonModes)
        }
    }
    
    func rtpick() {
        PrintFM("\(rtcount)")
        if rtcount<=0 {
            rtimer?.invalidate()
            rtimer = nil
            label_time.text = "重发"
            rtcount = 10
        }else{
            
            label_time.text = "\(rtcount)"
            rtcount -= 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

