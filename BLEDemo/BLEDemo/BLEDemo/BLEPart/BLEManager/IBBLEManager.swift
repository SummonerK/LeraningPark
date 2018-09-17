//
//  IBBLEManager.swift
//  BLEDemo
//
//  Created by Luofei on 2018/9/11.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import CoreBluetooth
import SVProgressHUD

let BLEM = IBBLEManager.shared
let StoryBoard_BLE = UIStoryboard.init(name: "BLE", bundle: nil)

typealias BlEStats = (_ bletats:Bool) -> Void

class IBBLEManager: NSObject,XMBlueToothDelegate{
    
    var manager = XMBlueToothManager()
    var currPeripher:CBPeripheral?
    var channel:String = "perpheral"
    var characteristic:CBCharacteristic?
    
    var IBBack:BlEStats!
    
    var step:Int = 0
    
    var isConnect:Bool = false{
        didSet{
            if isConnect{
                
            }
        }
    }
    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    
    static let shared = IBBLEManager()
    // 重载并私有
    
    func showMsg(_ msg:String) -> Void {
        SVProgressHUD.show(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 0.8)        
    }
    
    private override init() {
        PrintFM("create 单例")
        self.manager = XMBlueToothManager.default()
    }
    
    func searchBLEPeripheral() {
        PrintFM("")
    }
    
    func gotoManagerPages() -> Void {
        
        let Vc = StoryBoard_BLE.instantiateViewController(withIdentifier: "BLENaviC") as! BLENaviC
        
        UIApplication.shared.keyWindow?.rootViewController?.present(Vc, animated: true, completion: nil)
    }
    
    func backBleStats(bleb: @escaping BlEStats) -> Void {
        
        self.IBBack = bleb
        
        if step == 1{
            
//            managerValuePer()
            
            self.manager.delegate = self
        }
        if step == 2{
            
//            managerValueCharacteristic()
            
            self.manager.delegate = self
        }
        
    }
    
    func managerValuePer() -> Void {
        //连接外设
        
        self.manager.cancleAllConnect()
        
        step = 1
        
        self.channel = "perpheral"
        
        self.manager.connectToPeripheral(withChannel: self.channel, peripheral: self.currPeripher)
        
        self.manager.xm_readValueForCharacter { (peripheral, characteristics, error) in
            
        }
        self.manager.xm_readValueForDescriptors { (peripheral, descriptor, error) in
            
        }
        self.manager.xm_discoverDescriptorsForCharacteristic { (peripheral, characteristics, error) in

        }
        
        //        外设断开连接的回调
        self.manager.xm_blockOnDisconnect { (central, peripheral, error) in

            SVProgressHUD.showError(withStatus: "blockOnDisconnect 已经断开连接，请重新连接")
        }
        // 断开连接失败的回调
        self.manager.xm_disconnect { (central, peripheral, error) in
            SVProgressHUD.showError(withStatus: "disconnect 已经断开连接，请重新连接")
        }
        //连接成功与否
        self.manager.xm_connectState { (state) in
//            if state{
//                SVProgressHUD.showSuccess(withStatus: "connectState 连接成功");
//            }else{
//                SVProgressHUD.showError(withStatus: "connectState 已经断开连接，请重新连接")
//            }
            
            PrintFM(state)
        }
        
//        self.manager.xm_peripheralManagerDidUpdateState { (peripheral) in
//            
//            if let isAdvertising = peripheral?.isAdvertising,isAdvertising{
//                SVProgressHUD.showSuccess(withStatus: "DidUpdateState 连接成功");
//            }else{
//                SVProgressHUD.showError(withStatus: "DidUpdateState 已经断开连接，请重新连接")
//            }
//        }
        
        //添加重连
        self.manager.xm_addAutoReconnectPeripheral(self.currPeripher)
        
    }
    
    
    ///注册读取蓝牙服务连接
    func managerValueCharacteristic() -> Void {
        
        step = 2
        
        self.channel = "CBCharacteristic"
        
        self.manager.readDetailValueOfCharacteristic(withChannel: self.channel, characteristic: self.characteristic, currPeripheral: self.currPeripher)
        self.managerDelegate()
    }
    
    /// 根据信号强度算距离
    ///
    /// - Parameter RSSI: 信号强度值
    /// - Returns: 距离
    func getDistanceWith(RSSI:NSNumber) -> CGFloat {
        let power:Float = abs(RSSI.floatValue - 49.0)/(10*4.0)
        return CGFloat(powf(10.0, power)/10.0)
    }
    
    func managerDelegate(){
        //实时读取外设的RSSI
        
        self.manager.xm_didReadRSSI { (RSSI, error) in
            PrintFM( ("setBlockOnDidReadRSSI:\(String(describing: RSSI))"))
            let distance:CGFloat? = self.getDistanceWith(RSSI: RSSI!)
            PrintFM( distance)
        }
        self.manager.xm_readRSSI { (RSSI, error) in
            PrintFM( RSSI)
        }
        self.manager.xm_blockOnDisconnect { (central, peripheral, error) in
            PrintFM( "连接失败")
            SVProgressHUD.showError(withStatus: "C blockOnDisconnect已经断开连接，请重新连接")
        }
        
        self.manager.xm_connectState { (isConnect) in
            PrintFM( "")
            if isConnect{
                SVProgressHUD.showSuccess(withStatus: "C connectState连接成功");
            }else{
                SVProgressHUD.showError(withStatus: "C connectState已经断开连接，请重新连接")
            }
        }
        
        self.manager.xm_peripheralManagerDidUpdateState { (peripheral) in

            if let isAdvertising = peripheral?.isAdvertising,isAdvertising{
                SVProgressHUD.showSuccess(withStatus: "C DidUpdateState 连接成功");
            }else{
                SVProgressHUD.showError(withStatus: "C DidUpdateState 已经断开连接，请重新连接")
            }
        }
        
        //添加重连设备
        self.manager.xm_addAutoReconnectPeripheral(self.currPeripher)
        //写出值成功的回调
        self.manager.xm_didWriteValueForCharacteristic { (characteristic, error) in
            if error == nil{
                SVProgressHUD.showInfo(withStatus: "写入成功啦")
            }
        }
    }
    
    func chaManagerDidUpdateState(_ back: Bool) {
        
        self.IBBack(back)
        
        if back{
            HUDShowMsgQuick("cha 连接成功", 0.8)
//            SVProgressHUD.showSuccess(withStatus: "cha 连接成功");
        }else{
            HUDShowMsgQuick("cha 已经断开连接，请重新连接", 0.8)
//            SVProgressHUD.showError(withStatus: "cha 已经断开连接，请重新连接")
        }
    }

}
