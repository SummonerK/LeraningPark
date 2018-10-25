//
//  BLEListVC.swift
//  RootPrint
//
//  Created by Luofei on 2018/10/24.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

extension UITableView{
    
    public func registerNibName(_ aClass:AnyClass) -> Void{
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: className)
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

class BLEListVC: UIViewController {

    @IBOutlet weak var tv_main: UITableView!
    
    let baby = BabyBluetooth.share()
    var peripheralDataArray = [BlueToothEntity]()
    var services = [PeripheralInfo]()
    var currentServiceCharacteristics = [CBCharacteristic]()
    var currPeripheral: CBPeripheral?
    let rhythm = BabyRhythm()
    //var sect = ["red", "write", "desc", "properties"]
    var readValueArray = [NSData]()
    var descriptors = [CBDescriptor]()
    
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
        
        babyDelegate1()
        
//        baby?.cancelAllPeripheralsConnection()
        _ = baby?.scanForPeripherals().begin()
        
        // Do any additional setup after loading the view.
    }
    
    func setData(peripheral: CBPeripheral, advertisementData: Dictionary<String, Any>, RSSI: NSNumber) {
        
        var peripherals = [CBPeripheral]()
        for index in 0 ..< Int(peripheralDataArray.count) {
            if let peripheral_ = peripheralDataArray[index].peripheral {
                peripherals.append(peripheral_)
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
    
    //返回操作响应
    @IBAction func cancelAction(_ sender: Any) {
        
        super.view.sendSubview(toBack: self.view)
        
        self.view.isHidden = true
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

extension BLEListVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return peripheralDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
//        if section == 0{
//            return 12
//        }else{
//            return 0.1
//        }
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellBleroot", for: indexPath) as! TCellBleroot
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let Cindex = peripheralDataArray[indexPath.section]
        
        let rssi = Cindex.RSSI ?? 2
        
//        cell.label_title.text = "rssi"
        
        cell.label_title.text = (Cindex.peripheral?.name)! + "【\(rssi)】"
        
        cell.label_des.text = "\(String(describing: (Cindex.advertisementData ?? [:]).description))"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
