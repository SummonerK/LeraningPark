//
//  ViewController.swift
//  RootPrint
//
//  Created by Luofei on 2018/10/24.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

import SVProgressHUD

class ViewController: UIViewController {
    
    var coverItemVC: BLEListVC! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCoverView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removePhoto(noti:)), name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc fileprivate func removePhoto(noti : Notification) {
        
//        SVProgressHUD.showError(withStatus: "设备连接断开,需要重新连接!!!")
        
        coverItemVC.reAchive()
    }
    
    func showBLEListV() -> Void {
        print("showBLEListV")
        showCoverView()
    }
    
    func showBLEChaListV() -> Void {
        print("showBLEChaListV")
    }
    
    func setCoverView(){
        
        coverItemVC = BLEListVC(nibName: "BLEListVC", bundle: nil)
        
        self.addChildViewController(coverItemVC)
        
        coverItemVC.view.frame = self.view.frame
        
        self.view.addSubview(coverItemVC.view)
        
        self.view.sendSubview(toBack: coverItemVC.view)
        
        coverItemVC.view.isHidden = true
        
    }
    
    func showCoverView() {
        
        coverItemVC.babyScan()
        
        coverItemVC.view.isHidden = false
        self.view.bringSubview(toFront: coverItemVC.view)
    }
    
    func closeCoverView() {
        coverItemVC.view.isHidden = true
//        self.view.sendSubview(toBack: coverItemVC.view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showBLEViews(_ sender: Any) {
        
//        (self.navigationController as! RootNaviC).showBLEListV()
//        
//        (self.navigationController as! RootNaviC).showBLEChaListV()
//        switch coverItemVC.BLEChoose.IBLcurrPeripheral?.state {
//        case .disconnected:
//            print("disconnected")
//        default:
//            print("disconnected")
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
        
        IBLVoiceManager.shared.speechWeather(with: "开始设置蓝牙配置")
        
//        showBLEListV()
    }
    
    @IBAction func BLEWrite(_ sender: Any) {
        
        if coverItemVC.isWritting{
            
            coverItemVC.writeZero(data: PrinterInit())
        }else{
            SVProgressHUD.showError(withStatus: "蓝牙连接出了问题!!!")
        }
    }
    
    @IBAction func BLEAchive(_ sender: Any) {
        
        coverItemVC.reAchive()
    }
    
    @IBAction func BLECoredata(_ sender: Any) {
        
//        let tag = (sender as! UIButton).tag
//        
//        switch tag {
//        case 1:
//            IBLFileM.save("fm00003", Date(), .WM_SUCCESS)
//        case 2:
//            IBLFileM.update("fm00003", Date(), .WM_SUCCESS)
//        case 3:
//            let array = IBLFileM.getdate("fm00003")
////            PrintFM("\(array)")
//            
//        default:
//            PrintFM("")
//        }
        
        
    }
    
    
    func PrinterInit() -> Data {
        let printInfo = HLPrinter.init()
//        let partnerName = "FMPOS"
//        let str1 = "测试电商服务中心(销售单)"
//        printInfo.appendText(partnerName, alignment: HLTextAlignment.center, fontSize: HLFontSize.titleBig)
//        printInfo.appendText(str1, alignment: HLTextAlignment.center)
        printInfo.appendLeftText("品名", middleText: "数量／单价", rightText: "金额", isTitle: true)
//        printInfo.appendLeftText("炝锅素1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendLeftText("炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendSeperatorLine()
//        printInfo.appendBarCode(withInfo: "SXA1205O58029444238")
//        printInfo.appendQRCode(withInfo: "SXA1205O58029444238_20180931")
//        printInfo.appendSeperatorLine()
        printInfo.appendFooter("非码提供技术支持")
        
        return printInfo.getFinalData()
    }

}

