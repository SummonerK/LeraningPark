//
//  ViewController.swift
//  KeyWords
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        whereUse()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
//    where
    
    func whereUse(){
        let str:String? = "萧萧"
        if let st = str, st != "明明" {
            PrintFM("看错人了")
        }else{
            PrintFM("确实是萧萧")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

