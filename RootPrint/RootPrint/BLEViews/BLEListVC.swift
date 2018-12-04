//
//  BLEListVC.swift
//  RootPrint
//
//  Created by Luofei on 2018/10/24.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import SVProgressHUD
import CryptoSwift

/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width

let BLEDisconnetNoticeName = "BLEDisconnetNoticeName"

extension UITableView{
    
    public func registerNibName(_ aClass:AnyClass) -> Void{
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
}

extension DispatchQueue {
    func after(_ delay: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}

class BlueToothEntity: NSObject {
    var peripheral: CBPeripheral?
    var RSSI: NSNumber?
    var advertisementData: Dictionary<String, Any>?
}

class PeripheralInfo: NSObject {
    var serviceUUID: CBUUID?
    var characteristics: [CBCharacteristic]?
}

///已连接蓝牙设备信息集合
class ChooseToothEntity: NSObject {
    var IBLentity:BlueToothEntity?
    var serviceUUID: CBUUID?
    var IBLcurrPeripheral: CBPeripheral?
    var IBLCha:CBCharacteristic?
}

class BLEListVC: UIViewController {

    @IBOutlet weak var tv_main: UITableView!
    @IBOutlet weak var tv_maincha: UITableView!
    
    @IBOutlet weak var chaSpace: NSLayoutConstraint!
    
    let baby = BabyBluetooth.share()
    var peripheralDataArray = [BlueToothEntity]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        BLEM.showMsg("RootView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv_main.registerNibName(TCellBleroot.self)
        
        tv_main.estimatedRowHeight = 100
        tv_main.rowHeight = UITableViewAutomaticDimension
        
        tv_maincha.registerNibName(TCellBleroot.self)
        
        tv_maincha.estimatedRowHeight = 100
        tv_maincha.rowHeight = UITableViewAutomaticDimension
        
//        babyScan()
        
        // Do any additional setup after loading the view.
    }
    
    //  MARK:- 页面操作
    //返回操作响应
    @IBAction func cancelAction(_ sender: Any) {
        
//        baby?.cancelAllPeripheralsConnection()
        
        if isCha{
            closeChaV()
        }else{

            //TODO:判断蓝牙设置情况
            //如果设置信息不全，则：提示设置信息不全，忽略现有连接以及特性。
            guard let blenul = BlesetNull() else {
                SVProgressHUD.showError(withStatus: "蓝牙信息配置不全")
                IBLVoiceManager.shared.speechWeather(with: "蓝牙信息配置不全，功能重启")
                baby?.cancelAllPeripheralsConnection()
                self.view.isHidden = true
                return
            }
            
            //重连新特性
//            if blenul {
//                self.reAchive()
//            }
            
            self.view.isHidden = true
        }
        
    }
    
    //  MARK:- tableViewCha Controller
    func closeChaV() -> Void {
        isCha = false
        chaSpace.constant = IBScreenWidth
    }
    
    func openChaV() -> Void {
        chaSpace.constant = 0
        isCha = true
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
            
//            let indexPath = NSIndexPath.init(row: 0, section: self.peripheralDataArray.count)
            
            let item = BlueToothEntity()
            item.peripheral = peripheral
            item.RSSI = RSSI
            item.advertisementData = advertisementData
            peripheralDataArray.append(item)
            
            tv_main.reloadData()
            
//            tv_main.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
        
        
//        for index in 0 ..< Int(peripheralDataArray.count) {
//            print("======>>>>>>1")
//            print(peripheralDataArray[index].peripheral ?? "1")
//            print("======>>>>>>2")
//            print(peripheralDataArray[index].RSSI ?? "2")
//            print("======>>>>>>3")
//            print(peripheralDataArray[index].advertisementData ?? "3")
//        }
        
    }
    
    func setData2(service: CBService) {
        print("搜索到服务: \(service.uuid.uuidString)")
        let info = PeripheralInfo()
        info.serviceUUID = service.uuid
        info.characteristics = [CBCharacteristic]()
        
        self.services.append(info)
        
        tv_maincha.reloadData()
    }
    
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
            
            //MARK:-重连蓝牙总结 step2
            ///扫描到服务的特性并自动重连
            if info.serviceUUID == BLEChoose.serviceUUID {
                //连接特性
                redOrWriteBtnAction()
            }
            
            tv_maincha.reloadData()
        }
        
        if let characteristics_ = service.characteristics {
            self.currentServiceCharacteristics = characteristics_
        }
    }
    //MARK:蓝牙重连机制
    ///reAchive
    func reAchive() -> Void {
        
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
                
                if !self.isConecting{
                    IBLVoiceManager.shared.speechWeather(with: "连接失败，请尝试手动虫连")
                    HUDShowMsgQuick("蓝牙打印设备连接超时,请检查设备后尝试手动虫连", 0.8)
                    SVProgressHUD.dismiss(withDelay: 0.8)
                }else{
                    IBLVoiceManager.shared.speechWeather(with: "本次虫连，心跳成功")
                    SVProgressHUD.dismiss(withDelay: 0.2)
                }
            }
            
            closeChaV()
            baby?.cancelAllPeripheralsConnection()
            babyDelegate1()
            _ = baby?.scanForPeripherals().begin()
        }
        
//        if blenul && !isSetting{
//            IBLVoiceManager.shared.speechWeather(with: "蓝牙设备连接中，，，请等待")
//            DispatchQueue.main.after(10) {
//                IBLVoiceManager.shared.speechWeather(with: "连接失败，请尝试手动虫连")
//                HUDShowMsgQuick("蓝牙打印设备连接超时,请检查设备后尝试手动虫连", 0.8)
//                SVProgressHUD.dismiss(withDelay: 0.8)
//            }
//            
//            closeChaV()
//            isSetting = true
//            baby?.cancelAllPeripheralsConnection()
//            babyDelegate1()
//            _ = baby?.scanForPeripherals().begin()
//        }
        
        
//        IBLVoiceManager.shared.speechWeather(with: "开始虫连蓝牙设备")
//        
////        SVProgressHUD.setDefaultMaskType(.gradient)
//        
//        DispatchQueue.main.after(10) {
//            IBLVoiceManager.shared.speechWeather(with: "虫连失败，请尝试手动虫连")
////            SVProgressHUD.showError(withStatus: "蓝牙打印设备连接超时,请检查设备后尝试手动虫连")
//            HUDShowMsgQuick("蓝牙打印设备连接超时,请检查设备后尝试手动虫连", 0.8)
////            SVProgressHUD.dismiss(withDelay: 0.2)
//        }
//        
//        closeChaV()
//        babyDelegate1()
////        baby?.cancelAllPeripheralsConnection()
//        _ = baby?.scanForPeripherals().begin()
    }
    
    //MARK:蓝牙重连判空
    func BlesetNull() -> Bool? {
        if BLEChoose.IBLCha == nil || BLEChoose.IBLcurrPeripheral == nil || BLEChoose.IBLentity == nil || BLEChoose.serviceUUID == nil {
            return nil
        }else{
            return true
        }
    }
    
    
    //  MARK:- 扫描设备 
    //  以供选择连接设备
    //  :选择连接设备
    //  点击开启第一步
    func babyScan() -> Void{
        
        BLEChoose = ChooseToothEntity()
        
        closeChaV()
        babyDelegate1()
        baby?.cancelAllPeripheralsConnection()
        _ = baby?.scanForPeripherals().begin()
    }
    
    //  MARK:- 连接设备 
    /// 连接已选择的设备
    //  选择设备服务
    /// 点击开启第二步
    func lightBtnAction() {
        openChaV()
        services.removeAll()
        tv_maincha.reloadData()
        self.baby?.cancelScan()
//        _ = self.baby?.scanForPeripherals()
        self.babyDelegate2()
        self.loadData()
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
        
//        SVProgressHUD.dismiss(withDelay: 0.2)
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

    
    ///连接已选择的设备
    func loadData() {
        
        baby?.cancelAllPeripheralsConnection()
        
        print("俺要开始连接设备...")
        
        guard let entityperipheral = self.BLEChoose.IBLentity?.peripheral else {
            print("没有搜索到您想链接的蓝牙")
            return
        }
        
        _ = baby?.having(entityperipheral).and().channel("peripheralView").then().connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BLEListVC{
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
            
//TODO:设备连接处
//                if (peripheralName.hasPrefix("Printer")) {
//                    print("搜索到了设备: \(peripheralName)")
//                    self.setData(peripheral: peripheral!, advertisementData: advertisementData as! Dictionary<String, Any>, RSSI: RSSI!)
////                    self.baby?.cancelScan()
//                }
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
//                //最常用的场景是查找某一个前缀开头的设备
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

//        baby?.setBlockOnFailToConnect({ (central, peripheral, error) in
////            SVProgressHUD.showSuccess(withStatus: "设备\(peripheralName)连接成功!!!")
//            if let peripheralName = peripheral?.name {
//                print("设备\(peripheralName)连接成功!!!")
//                SVProgressHUD.showSuccess(withStatus: "设备\(peripheralName)断开链接!!!")
//            }
//        })
        
        baby?.setBlockOnFailToConnectAtChannel("peripheralView", block: { (central, peripheral, error) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)断开链接!!!")
                SVProgressHUD.showError(withStatus: "设备\(peripheralName)断开链接!!!")
            }
        })
        
        //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调 1
        baby?.setBlockOnConnectedAtChannel("peripheralView", block: { (central, peripheral) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接成功!!!")
                SVProgressHUD.showSuccess(withStatus: "设备\(peripheralName)连接成功!!!")                
                HUDShowMsgQuick("设备\(peripheralName)连接成功!!!", 1)
                
                self.isConecting = true
                
                //TODO:设备重连判断。
//                guard let blenul = self.BlesetNull() else {
//                    return
//                }
//                
//                if blenul{
//                    DispatchQueue.main.after(2) {
//                        IBLVoiceManager.shared.speechWeather(with: "蓝牙配置完成，请测试打印操作")
//                    }
//                }
                
            }
        })
        
        //设置设备连接失败的委托 2
        baby?.setBlockOnFailToConnectAtChannel("peripheralView", block: { (central, peripheral, error) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接失败!!!")
                SVProgressHUD.showError(withStatus: "设备\(peripheralName)连接失败!!!")
                HUDShowMsgQuick("设备\(peripheralName)连接失败!!!", 1)
            }
        })
        
        //设置设备断开连接的委托 3
        baby?.setBlockOnDisconnectAtChannel("peripheralView", block: { (central, peripheral, error) in
            if let peripheralName = peripheral?.name {
                print("设备\(peripheralName)连接断开!!!")
//  TODO: 连接打印的 频道Channel 断开连接，则发出通知，让rootvc 唤起runloop 来自动重连蓝牙打印设备和服务。如果连接5次重连失败，则断开蓝牙连接。
//                self.isSetting = false
//                self.isConecting = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
//                SVProgressHUD.showError(withStatus: "设备\(peripheralName)连接断开!!!")
                HUDShowMsgQuick("设备\(peripheralName)连接断开!!!", 1)
            }
        })
        
        //设置发现设备的Services的委托 4
        baby?.setBlockOnDiscoverServicesAtChannel("peripheralView", block: { [unowned self] (peripheral, error) in
            if let service_ = peripheral?.services {
                for mService in service_ {
                    
//                    mService.characteristics
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
                
//                if (service_.uuid.uuidString == "EC5F093D-D259-4626-B909-A830CFCFB5E2") { // 这里是 我写死的一个调试的蓝牙设备的service uuid 可以自己替换
//                    self.setData3(service: service_)
//                }
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
}

extension BLEListVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == tv_maincha {
            return self.services.count
        }
        
        return peripheralDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tv_maincha {
            let info = self.services[section]
            
            guard let chalist = info.characteristics else {
                return 0
            }
            
            return chalist.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if tableView == tv_maincha{
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
            let info = self.services[section]
            label.text = String.init(format: "UUID： %@", info.serviceUUID ?? "")
            label.backgroundColor = UIColor.black
            label.textColor = UIColor.white
            return label
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if tableView == tv_maincha{
            return 50
        }
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tv_maincha{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellBleroot", for: indexPath) as! TCellBleroot
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            //服务特性
            
            let info = self.services[indexPath.section]
            let characteristic = info.characteristics?[indexPath.row]
            
            cell.label_des.text = "服务特性"
            cell.label_subtitle.text = String.init(format: "%@", (characteristic?.uuid.uuidString)!)
            
            let value:(String,Bool) = getCharacterDes(characteristic!.properties)
            cell.label_title.text = value.0
            
            cell.backgroundColor = value.1 ? UIColor.white:UIColor.lightGray
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellBleroot", for: indexPath) as! TCellBleroot
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let Cindex = peripheralDataArray[indexPath.section]
        
        let rssi = Cindex.RSSI ?? 2
        
        cell.label_title.text = (Cindex.peripheral?.name)! + "【\(rssi)】"
        
        cell.label_subtitle.text = "\(String(describing: (Cindex.advertisementData ?? [:]).description))"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == tv_maincha{
            
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tv_maincha{
            
            //服务特性
            
            let info = self.services[indexPath.section]
            let characteristic = info.characteristics?[indexPath.row]
            
            let value:(String,Bool) = getCharacterDes(characteristic!.properties)
            
            BLEChoose.IBLCha = value.1 ? characteristic : nil
            BLEChoose.serviceUUID = info.serviceUUID
            
            //连接特性
            redOrWriteBtnAction()
            
        }
        
        if tableView == tv_main{
            
            let cindx = peripheralDataArray[indexPath.section]
            
            BLEChoose.IBLentity = cindx
            BLEChoose.IBLcurrPeripheral = cindx.peripheral
            
            lightBtnAction()
        }
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
