//
//  BLERootVC.swift
//  BLEDemo
//
//  Created by Luofei on 2018/9/11.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD

// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

extension UITableView{
    
    public func registerNibName(_ aClass:AnyClass) -> Void{
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
}

/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}

func HUDShowMsgQuick(_ msg:String,_ time:Float){
    
    let hud = MBProgressHUD.showAdded(to: KeyWindow, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.label.text = msg
    hud.tintColor = UIColor.clear
    hud.isUserInteractionEnabled = true
    
    hud.offset = CGPoint.init(x: 0, y: 80)
    
    //延迟隐藏
    hud.hide(animated: true, afterDelay: TimeInterval(time))
}


/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width
// iphone X
let isIphoneX = IBScreenHeight == 812 ? true : false
let naviXBarHeight : CGFloat = isIphoneX ? 88 : 64
let naviXBtonTop:CGFloat = isIphoneX ? 44 : 20
let bottmXBtonH:CGFloat = isIphoneX ? 49+34 : 49

class BLERootVC: UIViewController {
    
    @IBOutlet weak var naviBtonTop: NSLayoutConstraint!
    @IBOutlet weak var naviHeight: NSLayoutConstraint!
    @IBOutlet weak var botmHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tv_main: UITableView!
    
    var peripherals = NSMutableArray()
    var peripheralsAD = NSMutableArray()
    var dataSource = NSMutableArray()
    
    var peripheralDataArray = [BlueToothEntity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        BLEM.showMsg("RootView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBtonTop.constant = naviXBtonTop
        naviHeight.constant = naviXBarHeight
        botmHeight.constant = 0
        
        
        BLEM.manager.cancleAllConnect()
        
        //暂时关闭断开连接 清空连接设备和连接特性。
//        BLEM.currPeripher = nil
//        BLEM.characteristic = nil
        
        SVProgressHUD.showInfo(withStatus: "准备打开设备")
        self.peripherals = NSMutableArray.init()
        self.peripheralsAD = NSMutableArray.init()
        self.dataSource = NSMutableArray.init()
//        BLEM.manager = XMBlueToothManager.default()
        self.setDelegate()
        tv_main.registerNibName(TCellBleroot.self)

        // Do any additional setup after loading the view.
    }
    
    //返回操作响应
    @IBAction func cancelAction(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        BLEM.manager.beginToScan()
    }
    
    func isConnectedPeripherals() -> Bool {
        PrintFM("")
        
        return true
    }
    
    func setDelegate() {
        
        BLEM.manager.xm_discoverPeripherals { (central, peripheral, advertisementData, RSSI) in
            //        XMLog(message: (peripheral?.name,RSSI))
//            peripheral.
            
            var peripherals = [CBPeripheral]()
            for index in 0 ..< Int(self.peripheralDataArray.count) {
                if let peripheral_ = self.peripheralDataArray[index].peripheral {
                    peripherals.append(peripheral_)
                }
            }
            
            if (!(peripherals.contains(peripheral!))) {
                let item = BlueToothEntity()
                item.peripheral = peripheral
                item.RSSI = RSSI
                item.advertisementData = advertisementData as? Dictionary<String, Any>
                self.peripheralDataArray.append(item)
            }
            
            for index in 0 ..< Int(self.peripheralDataArray.count) {
                print("======>>>>>>1")
                print(self.peripheralDataArray[index].peripheral ?? "1")
                print("======>>>>>>2")
                print(self.peripheralDataArray[index].RSSI ?? "2")
                print("======>>>>>>3")
                print(self.peripheralDataArray[index].advertisementData ?? "3")
            }
            
            self.insertTableView(peripheral: peripheral!, advertisementData: advertisementData! as NSDictionary)
        }
        BLEM.manager.xm_setFilter { (peripheralName, advertisementData, RSSI) -> Bool in
            if peripheralName != nil{//设置过滤条件
                return true
            }else{
                return false
            }
        }
    }
    
    
    func insertTableView(peripheral:CBPeripheral,advertisementData:NSDictionary) -> Void {
        if !self.peripherals.contains(peripheral) {
            let indexPath = NSIndexPath.init(row: self.peripherals.count, section: 0)
            self.peripherals.add(peripheral)
            self.peripheralsAD.add(advertisementData)
            self.tv_main.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
        self.tv_main.reloadData()
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

extension BLERootVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 0{
            return 12
        }else{
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellBleroot", for: indexPath) as! TCellBleroot
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let peripheral = self.peripherals.object(at: indexPath.row) as! CBPeripheral
        let ad = peripheralsAD.object(at: indexPath.row) as! NSDictionary
        
        var localName = String()
        if (ad.object(forKey: "kCBAdvDataLocalName") != nil) {
            localName = ad.object(forKey: "kCBAdvDataLocalName") as! String
        }else{
            localName = peripheral.name!
        }
        
        cell.label_title.text = localName
//        cell.label_subtitle.text = "未读取到服务信息"
//        if (ad.object(forKey: "kCBAdvDataServiceUUIDs") != nil) {
//            let serviceUUIDs = ad.object(forKey: "kCBAdvDataServiceUUIDs") as! NSArray
//            if serviceUUIDs.count > 0 {
//                cell.label_subtitle.text = String.init(format: "%lu个服务", serviceUUIDs.count)
//            }else{
//                cell.label_subtitle.text = "0个服务"
//            } 
//        }
        
//        cell.label_subtitle.text = getJSONStringFromDictionary(dictionary: ad)
        
        cell.label_subtitle.text = ad.description
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
//        return 68
        
        return 300
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        BLEM.manager.cancleScan()
        
        let per = self.peripherals.object(at: indexPath.row) as! CBPeripheral
        
        let VC = BLEServicesVC.init(nibName: "BLEServicesVC", bundle: nil)
        
        BLEM.currPeripher = per
        
        VC.chuanzhi(currentPeripheral: per)
        
        self.navigationController?.pushViewController(VC, animated: true)
        
//        PrintFM("\(indexPath.row)")
        
    }
    
}
