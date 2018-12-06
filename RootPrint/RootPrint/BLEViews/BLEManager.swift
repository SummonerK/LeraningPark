//
//  BLEManager.swift
//  RootPrint
//
//  Created by Luofei on 2018/12/5.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import SVProgressHUD

let BLEM = BLEManager.shared

typealias IBBLEBack = (_ blets:[String]) -> Void

class BLEManager: NSObject {
    
    /// 单例管理语音播报 比较适用于多种类型语音播报管理
    public static let shared = BLEManager()
    
    let baby = BabyBluetooth.share()
    var peripheralDataArray = [BlueToothEntity]()//搜索到设备的集合【供选择使用】
    var chaDataArray = [CBCharacteristic]()//搜索到设备特性的集合【供选择使用】
    
    var services = [PeripheralInfo]()
    var currentServiceCharacteristics = [CBCharacteristic]()
    var currPeripheral: CBPeripheral?
    var isCha:Bool = false //蓝牙设备-特性 Flag
    var isSetting:Bool = false  //连接设备 Flag
    var isWritting:Bool = false  //写入业务 Flag
    var isConecting:Bool = false  //连接蓝牙 Flag
    let rhythm = BabyRhythm()
    //var sect = ["red", "write", "desc", "properties"]
    var readValueArray = [NSData]()
    var descriptors = [CBDescriptor]()
    //已选择属性集合
    var BLEChoose = ChooseToothEntity()
    
    ///单例分离。参数
    var arrayBlets = [String]()
    {
        didSet{
            ibBletsback(arrayBlets)
        }
    }
    
    var arrayChas = [String]()
    {
        didSet{
            ibChasback(arrayChas)
        }
    }
    
    var ibBletsback:IBBLEBack!
    var ibChasback:IBBLEBack!
    
    
    
    ///单例分离。OPEN 方法
    
    func testAdd() {
        arrayBlets.append("device2h3k")
    }
    func testChaAdd() {
        arrayChas.append("cha2334553")
    }
    
    func IBBLEDevice(back:@escaping IBBLEBack) -> Void {
        ibBletsback = back
    }
    
    
    func IBBLEChas(back:@escaping IBBLEBack) -> Void {
        ibChasback = back
    }
    
    func IBLLinkBLE(deviceIdx:Int) -> Void {
        
        IBLVoiceManager.shared.speechWeather(with: "开始连接，\(deviceIdx)的蓝牙设备")
        
        DispatchQueue.main.after(2) {
            let cindx = self.peripheralDataArray[deviceIdx]
            self.BLEChoose.IBLentity = cindx
            self.BLEChoose.IBLcurrPeripheral = cindx.peripheral
            self.lightBtnAction()
        }
        
    }
    
    func IBLLinkBLE(chaIdx:Int) -> Void {
        
        let cindx = chaDataArray[chaIdx]
        let udid = arrayChas[chaIdx]
        
        BLEChoose.IBLCha = cindx
        BLEChoose.serviceUUID = CBUUID.init(string: udid)
        
        //连接特性
        redOrWriteBtnAction()
    }
    
    func IBReachive() -> Void {
        if BLEChoose.IBLcurrPeripheral?.state == .connected{
            IBLVoiceManager.shared.speechWeather(with: "蓝牙连接正常")
            SVProgressHUD.dismiss(withDelay: 0.2)
            return
        }
        
        isConecting = false
        
        //如果配置信息不全，则回归，不予重连。
        guard let blenul = BlesetNull() else {
            SVProgressHUD.showError(withStatus: "蓝牙信息配置不全，请重新设置")
            IBLVoiceManager.shared.speechWeather(with: "蓝牙信息配置不全，请重新设置")
            SVProgressHUD.dismiss(withDelay: 0.2)
            return
        }
        
        
        //重连蓝牙
        //  :首先断开所有蓝牙连接，避免Block混乱，重复推送。
        //  :建立Block绑定，业务重连
        if blenul{
            IBLVoiceManager.shared.speechWeather(with: "蓝牙设备连接中，，，请等待")
            DispatchQueue.main.after(10) {
                
                if !BLEM.isConecting{
                    IBLVoiceManager.shared.speechWeather(with: "连接失败，请尝试手动虫连")
                    HUDShowMsgQuick("蓝牙打印设备连接超时,请检查设备后尝试手动虫连", 0.8)
                    SVProgressHUD.dismiss(withDelay: 0.8)
                }else{
                    IBLVoiceManager.shared.speechWeather(with: "本次虫连，心跳成功")
                    SVProgressHUD.dismiss(withDelay: 0.2)
                }
            }
            
            baby?.cancelAllPeripheralsConnection()
            babyDelegate1()
            _ = baby?.scanForPeripherals().begin()
        }
    }
    
    
    fileprivate func appendService(info:PeripheralInfo) -> Void{
        
        guard let chars = info.characteristics else {
            return
        }
        
        for cha in chars {
            let value:(String,Bool) = self.getCharacterDes(cha.properties)
            
            if value.1{
                //添加待选特性
                chaDataArray.append(cha)
                //添加待选显示UDID
                arrayChas.append(cha.uuid.uuidString)
            }
            
        }
    }
    
    //MARK:蓝牙重连判空
    func BlesetNull() -> Bool? {
        if BLEChoose.IBLCha == nil || BLEChoose.IBLcurrPeripheral == nil || BLEChoose.IBLentity == nil || BLEChoose.serviceUUID == nil {
            return nil
        }else{
            return true
        }
    }
    
    
    //MARK:-重连蓝牙总结
    ///1、重连，先扫描蓝牙，与原连接蓝牙做比较，如果没找到原蓝牙连接，则显示现有可选蓝牙列表
    ///   如果匹配成功，则连接原蓝牙
    ///2、重连蓝牙服务和特性。搜索服务和特性，同1操作
    
    func setData(peripheral: CBPeripheral, advertisementData: Dictionary<String, Any>, RSSI: NSNumber) {
        
        var peripherals = [CBPeripheral]()
        for index in 0 ..< Int(peripheralDataArray.count) {
            if let peripheral_ = peripheralDataArray[index].peripheral {
                peripherals.append(peripheral_)
                //TODO:-重连蓝牙总结 step1
                if let aPer = BLEChoose.IBLcurrPeripheral, aPer == peripheral{
                    lightBtnAction()
                }
            }
        }
        
        
        if (!(peripherals.contains(peripheral))) {
            
            let item = BlueToothEntity()
            item.peripheral = peripheral
            item.RSSI = RSSI
            item.advertisementData = advertisementData
            
            //添加搜索到的蓝牙设备
            peripheralDataArray.append(item)
            //添加搜索到蓝牙设备的名字
            arrayBlets.append(peripheral.name ?? "未知名字蓝牙设备")
            
            
            
            HUDShowMsgQuick("搜索到设备\(peripheralDataArray.count)", 1)
            
        }
    }
    
    //loaddata 服务
    func setData2(service: CBService) {
        print("搜索到服务: \(service.uuid.uuidString)")
        let info = PeripheralInfo()
        info.serviceUUID = service.uuid
        info.characteristics = [CBCharacteristic]()
        
        self.services.append(info)
        
    }
    //loaddata 特性
    func setData3(service: CBService) {
        var sect:Int = -1
        
        for (index,item) in self.services.enumerated() {
            if (item.serviceUUID == service.uuid) {
                sect = index;
            }
        }
        
        if sect != -1 {
            let info = self.services[sect]
            
            var chaList = [CBCharacteristic]()
            
            for (index,item) in (service.characteristics?.enumerated())! {
                chaList.append(item)
            }
            
            info.characteristics = chaList
            
            //添加搜索到的服务，筛选可打印的 特性，以供选择
            self.appendService(info: info)
            
            //MARK:-重连蓝牙总结 step2
            ///扫描到服务的特性并自动重连
            if info.serviceUUID == BLEChoose.serviceUUID {
                //连接特性
                redOrWriteBtnAction()
            }
        }
        
        if let characteristics_ = service.characteristics {
            self.currentServiceCharacteristics = characteristics_
        }
    }
    
    
    //  MARK:- 扫描设备
    //  以供选择连接设备
    //  :选择连接设备
    //  点击开启第一步
    func babyScan() -> Void{
        
        BLEChoose = ChooseToothEntity()
        peripheralDataArray.removeAll()
        arrayBlets.removeAll()
        
        babyDelegate1()
        baby?.cancelAllPeripheralsConnection()
        _ = baby?.scanForPeripherals().begin()
    }
    
    //  MARK:- 连接设备
    /// 连接已选择的设备
    //  选择设备服务
    /// 点击开启第二步
    func lightBtnAction() {
        services.removeAll()
        self.baby?.cancelScan()
        self.babyDelegate2()
        self.loadData()
    }
    
    ///连接蓝牙设备
    func loadData() {
        
        baby?.cancelAllPeripheralsConnection()
        
        //清空重连
        chaDataArray.removeAll()
        arrayChas.removeAll()
        
        print("俺要开始连接设备...")
        
        guard let entityperipheral = self.BLEChoose.IBLentity?.peripheral else {
            print("没有搜索到您想链接的蓝牙")
            return
        }
        
        _ = baby?.having(entityperipheral).and().channel("peripheralView").then().connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin()
    }
    
    //  MARK:- 连接设备
    /// 连接已选择的设备
    //  选择设备服务
    /// 点击开启第三步
    func redOrWriteBtnAction() {
        self.babyDelegate3()
        
        guard let x = BLEChoose.IBLcurrPeripheral else {
            return
        }
        guard let y = BLEChoose.IBLCha else {
            return
        }
        let cc = baby?.channel("CharacteristicView").characteristicDetails() // 读取服务
        
        let _ = cc!(x,y)
        
        isWritting = true
    }
    
    func writeZero(data:Data) -> Void {
        
        guard let x = BLEChoose.IBLcurrPeripheral else {
            return
        }
        guard let y = BLEChoose.IBLCha else {
            return
        }
        
        x.writeValue(data, for: y, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    
    
    /**
     进行第一步: 搜索到周围所有的蓝牙设备
     */
    func babyDelegate1() {
        
        baby?.setBlockOnCentralManagerDidUpdateState({ (centeral) in // CBManagerState
            if (centeral?.state.rawValue == CBCentralManagerState.poweredOn.rawValue) {
                print("设备打开成功,开始扫描设备")
            }
        })
        //let a:
        //设置扫描到设备的委托 1
        baby?.setBlockOnDiscoverToPeripherals({ [unowned self](central, peripheral, advertisementData, RSSI) in
            if let peripheralName = peripheral?.name {
                print(peripheralName)
                
                self.setData(peripheral: peripheral!, advertisementData: advertisementData as! Dictionary<String, Any>, RSSI: RSSI!)
            }
        })
        
        //设置发现设service的Characteristics的委托 2
        baby?.setBlockOnDiscoverCharacteristics({ (peripheral, service, error) in
            if let service_ = service {
                print("service name:\(service_.uuid)")
                if let service_characteristics = service_.characteristics {
                    //var characteristic: CBCharacteristic?
                    for characteristic in service_characteristics {
                        print("charateristic name is \(characteristic.uuid)")
                    }
                }
            }
        })
        
        //设置读取characteristics的委托 3
        baby?.setBlockOnReadValueForCharacteristic({ (peripheral, characteristic, error) in
            if let characteristic_ = characteristic {
                print("characteristic name is \(characteristic_.uuid),and its value is \(String(describing: characteristic_.value))")
            }
        })
        
        //设置发现characteristics的descriptors的委托 4
        baby?.setBlockOnDiscoverDescriptorsForCharacteristic({ (peripheral, characteristic, error) in
            if let characteristic_ = characteristic {
                print("characteristic name: \(characteristic_.service.uuid)")
            }
            if let descriptors_ = characteristic?.descriptors {
                for descriptor in descriptors_ {
                    print("descriptor name is:\(descriptor.uuid)")
                }
            }
        })
        
        //设置读取Descriptor的委托 5
        baby?.setBlockOnReadValueForDescriptors({ (peripheral, descriptor, error) in
            if let descriptor_ = descriptor {
                print("descriptor name is: \(descriptor_.characteristic.uuid) and its value is: \(String(describing: descriptor_.value))")
            }
        })
        
        //设置查找设备的过滤器 6
        baby?.setFilterOnDiscoverPeripherals({ (peripheralName, advertisementData, RSSI) -> Bool in
            if let peripheralName_ = peripheralName {
                print(peripheralName_)
                //TODO:设备过滤器
                //最常用的场景是查找某一个前缀开头的设备
//                if (peripheralName_.hasPrefix("Printer")) {
//                    return true
//                }
                
                return true
            }
            return false
        })
        
        //babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调 7
        baby?.setBlockOnCancelAllPeripheralsConnectionBlock({ (centralManager) in
            print("cancelAllPeripheralsConnectionBlock 方法调用后的回调")
        })
        
        //babyBluettooth cancelScan方法调用后的回调 8
        baby?.setBlockOnCancelScanBlock({ (centralManager) in
            print("cancelScan方法调用后的回调")
        })
        
        let scanForPeripheralsWithOptions = [CBCentralManagerScanOptionAllowDuplicatesKey:true]
        // 连接设备 9
        baby?.setBabyOptionsWithScanForPeripheralsWithOptions(scanForPeripheralsWithOptions, connectPeripheralWithOptions: nil, scanForPeripheralsWithServices: nil, discoverWithServices: nil, discoverWithCharacteristics: nil)
    }
    
    
    /**
     进行第二步, 读取某个设备的某条service的所有信息
     */
    func babyDelegate2() {
        
        baby?.setBlockOnCentralManagerDidUpdateState({ (central) in
            
        })
        
        
        baby?.peripheralModelBlock(onPeripheralManagerDidUpdateState: { (peripheral) in
            guard let isAdvertising = peripheral?.isAdvertising else{
                return
            }
            
            if isAdvertising{
                SVProgressHUD.showSuccess(withStatus: "设备连接成功!!!")
            }else{
                SVProgressHUD.showError(withStatus: "设备连接失败!!!")
            }
            
        })
        
        //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调 1
        baby?.setBlockOnConnectedAtChannel("peripheralView", block: { (central, peripheral) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接成功!!!")
                SVProgressHUD.showSuccess(withStatus: "设备\(peripheralName)连接成功!!!")
                HUDShowMsgQuick("设备OnConnected连接成功!!!", 1)
                BLEM.isConecting = true
            }
        })
        
        //设置设备连接失败的委托 2
        baby?.setBlockOnFailToConnectAtChannel("peripheralView", block: { (central, peripheral, error) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接失败!!!")
                SVProgressHUD.showError(withStatus: "设备\(peripheralName)连接失败!!!")
//                HUDShowMsgQuick("设备OnFailToConnect连接失败!!!", 1)
                BLEM.isConecting = false
            }
        })
        
        //设置设备断开连接的委托 3
        baby?.setBlockOnDisconnectAtChannel("peripheralView", block: { (central, peripheral, error) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接断开!!!")
//  TODO: 连接打印的 频道Channel 断开连接，则发出通知，让rootvc 唤起runloop 来自动重连蓝牙打印设备和服务。如果连接5次重连失败，则断开蓝牙连接。
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
                HUDShowMsgQuick("设备OnDisconnect连接断开!!!", 1)
                BLEM.isConecting = false
            }
        })
        
        //设置发现设备的Services的委托 4
        baby?.setBlockOnDiscoverServicesAtChannel("peripheralView", block: { [unowned self] (peripheral, error) in
            if let service_ = peripheral?.services {
                for mService in service_ {
                    self.setData2(service: mService)
                }
            }
            // 开启计时
            self.rhythm.beats()
        })
        
        //设置发现设service的Characteristics的委托 5
        baby?.setBlockOnDiscoverCharacteristicsAtChannel("peripheralView", block: { (peripheral, service, error) in
            if let service_ = service {
                print("service name:\(service_.uuid)")
                self.setData3(service: service_)
            }
        })
        
        //设置读取characteristics的委托 6
        baby?.setBlockOnReadValueForCharacteristicAtChannel("peripheralView", block: { (peripheral, characteristics, error) in
            
            if characteristics != nil && characteristics!.value != nil {
                print("characteristic6 name is :\(String(describing: characteristics?.uuid)) and its value is: \(characteristics!.value!.bytes.toHexString())")
            }
            
/************************************* 注意这里注释了监听 ************************************************/
//            if (characteristics != nil) {
//                if (characteristics?.uuid.uuidString == "FFF0") {
//                    if (!(characteristics?.isNotifying)!) {
//                        peripheral?.setNotifyValue(true, for: characteristics!)
//                        print("开始监听\(characteristics)")
//                    }
//                }
//            }
            
        })
        
        //设置发现characteristics的descriptors的委托 7
        baby?.setBlockOnDiscoverDescriptorsForCharacteristicAtChannel("peripheralView", block: { (peripheral, characteristics, error) in
            if let characteristic_ = characteristics {
                print("characteristic name is :\(characteristic_.service.uuid)")
                if let descriptors_ = characteristic_.descriptors {
                    for descriptors in descriptors_ {
                        print("CBDescriptor name is:\(descriptors.uuid)")
                    }
                }
            }
        })
        
        //设置读取Descriptor的委托 8
        baby?.setBlockOnReadValueForDescriptorsAtChannel("peripheralView", block: { (peripheral, descriptor, error) in
            if let descriptors_ = descriptor {
                print("descriptor name is :\(descriptors_.uuid) and its value is: \(String(describing: descriptors_.value))")
            }
        })
        
        //读取rssi的委托 9
        baby?.setBlockOnDidReadRSSI({ (RSSI, error) in
            if let RSSI_ = RSSI {
                print("读取到RSSI:\(RSSI_)")
            }
        })
        
        //设置beats break委托 10
        rhythm.setBlockOnBeatsBreak { (bry) in
            print("setBlockOnBeatsBreak调用")
        }
        
        //设置beats over委托 11
        rhythm.setBlockOnBeatsOver { (bry) in
            print("setBlockOnBeatsOver调用")
        }
        
        //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
        let scanForPeripheralsWithOptions = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        
        /*连接选项->
         CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
         CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
         CBConnectPeripheralOptionNotifyOnNotificationKey:
         当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
         */
        let connectOptions = [CBConnectPeripheralOptionNotifyOnConnectionKey: true, CBConnectPeripheralOptionNotifyOnDisconnectionKey: true, CBConnectPeripheralOptionNotifyOnNotificationKey: true]
        
        baby?.setBabyOptionsAtChannel("peripheralView", scanForPeripheralsWithOptions: scanForPeripheralsWithOptions, connectPeripheralWithOptions: connectOptions, scanForPeripheralsWithServices: nil, discoverWithServices: nil, discoverWithCharacteristics: nil)
    }
    
    /**
     进行第三步-- 读写某个Characteristic
     */
    func babyDelegate3() {
        
        // 设置读取characteristics的委托  1
        baby?.setBlockOnReadValueForCharacteristicAtChannel("CharacteristicView", block: { (peripheral, characteristics, error) in
            print("CharacteristicView===>>> characteristic name: \(String(describing: characteristics?.uuid)) and value is : \(String(describing: characteristics?.value))")
        })
        
        //设置发现characteristics的descriptors的委托  2
        baby?.setBlockOnDiscoverDescriptorsForCharacteristicAtChannel("CharacteristicView", block: { (peripheral, characteristics, error) in
            print("CharacteristicView===>>>characteristic name: \(String(describing: characteristics?.service.uuid))")
            if (characteristics?.descriptors?.count != 0) {
                for d in (characteristics?.descriptors)! {
                    print("CharacteristicViewController CBDescriptor name is :\(d.uuid)")
                }
            }
        })
        
        //设置读取Descriptor的委托 3
        baby?.setBlockOnReadValueForDescriptorsAtChannel("CharacteristicView", block: {[unowned self] (peripheral, descriptor, error) in
            
            for i in 0..<self.descriptors.count {
                if (self.descriptors[i] == descriptor) {
                    print("我是委托3 --->>> 我找到对应的descriptor了")
                }
            }
            print("CharacteristicView Descriptor name:\(String(describing: descriptor?.characteristic.uuid)) value is:\(String(describing: descriptor?.value))")
        })
        
        //设置写数据成功的block    4
        baby?.setBlockOnDidWriteValueForCharacteristicAtChannel("CharacteristicView", block: { (characteristic, error) in
            print("setBlockOnDidWriteValueForCharacteristicAtChannel characteristic: \(String(describing: characteristic?.uuid)) and new value:\(String(describing: characteristic?.value))")
        })
        
        //设置通知状态改变的block    5
        baby?.setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel("CharacteristicView", block: { (characteristic, error) in
            
            print("uid:\(String(describing: characteristic?.uuid)), isNotifying: \((characteristic?.isNotifying)! ? "on" : "off")")
        })
    }
    
    
    func getCharacterDes(_ aCharacter:CBCharacteristicProperties) -> (String,Bool) {
        var Des:String = String.init()
        
        var isWrite:Bool = false
        
        if (aCharacter.contains(.broadcast)) {
            Des.append("| 广播")
        }
        if (aCharacter.contains(.read)) {
            Des.append(" | 读")
        }
//            if (p?.contains(.writeWithoutResponse))! {
//                cell?.textLabel?.text = cell?.textLabel?.text?.appending(" | WriteWithoutResponse")
//            }
        if (aCharacter.contains(.write)) {
            Des.append(" | 写")
            isWrite = true
        }
        if (aCharacter.contains(.notify)) {
            Des.append(" | 通知")
        }
        if (aCharacter.contains(.indicate)) {
            Des.append(" | 指示")
        }
        if (aCharacter.contains(.authenticatedSignedWrites)) {
            Des.append(" | 认证签名")
        }
        if (aCharacter.contains(.extendedProperties)) {
            Des.append(" | 扩展属性")
        }
        
        return (Des,isWrite)
    }

}
