//
//  ViewController.swift
//  BLEDemo
//
//  Created by Luofei on 2018/9/11.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

// MARK:封装的日志输出功能（T表示不指定日志信息参数类型）
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
    
    @IBOutlet weak var label_ble:UILabel!
    @IBOutlet weak var bton_connect:UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        BLEM.backBleStats { (isConnect) in
//            self.bton_connect.isHidden = isConnect
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(switchAction(notification:)), name: NSNotification.Name(rawValue: "BLESwitch"), object: nil)
        
//        bton_connect.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //通知内容接收
    func switchAction(notification: NSNotification) {
        let res:NSDictionary = notification.object as! NSDictionary
        
        HUDShowMsgQuick("switch", 0.8)
        
//        bton_connect.isHidden = !(res["switch"] as! Bool)
        
    }
    //选取操作响应
    @IBAction func gotoChooseAction(_ sender: Any) {
        
        BLEM.gotoManagerPages()
    }
    
    //打印
    @IBAction func writeAction(_ sender: Any) {
        
        if let cur = BLEM.currPeripher{
            
            PrintFM(cur.state)
            
            var localName = String()
            localName = cur.name!
            
            switch cur.state {
            case .connected:
                if let cha = BLEM.characteristic{
                    BLEM.manager.write(PrinterInit(), to: cur, for: cha)
                }else{
                    HUDShowMsgQuick("\(localName) 连接服务有误", 0.8)
                }
            case .connecting:
                HUDShowMsgQuick("\(localName) connecting", 0.8)
            case .disconnected:
                HUDShowMsgQuick("\(localName) disconnected", 0.8)
            case .disconnecting:
                HUDShowMsgQuick("\(localName) disconnecting", 0.8)
            }
        }else{
            HUDShowMsgQuick("尚未链接任何蓝牙设备", 0.8)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func PrinterInit() -> Data {
        let printInfo = HLPrinter.init()
//        let partnerName = "FMPOS"
//        let str1 = "测试电商服务中心(销售单)"
//        printInfo.appendText(partnerName, alignment: HLTextAlignment.center, fontSize: HLFontSize.titleBig)
//        printInfo.appendText(str1, alignment: HLTextAlignment.center)
        
        printInfo.appendLeftText("品名", middleText: "数量／单价", rightText: "金额", isTitle: true)
        printInfo.appendLeftText("炝锅素1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendLeftText("炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendSeperatorLine()
//        printInfo.appendBarCode(withInfo: "SXA1205O58029444238")
//        printInfo.appendQRCode(withInfo: "SXA1205O58029444238_20180931")
//        printInfo.appendSeperatorLine()
        printInfo.appendFooter("非码提供技术支持")
        
        return printInfo.getFinalData()
    }

}

