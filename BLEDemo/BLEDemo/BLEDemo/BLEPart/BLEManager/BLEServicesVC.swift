//
//  BLEServicesVC.swift
//  BLEDemo
//
//  Created by Luofei on 2018/9/11.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import SVProgressHUD
class BLEServicesVC: UIViewController {
    
    @IBOutlet weak var naviBtonTop: NSLayoutConstraint!
    @IBOutlet weak var naviHeight: NSLayoutConstraint!
    @IBOutlet weak var botmHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tv_main: UITableView!
    var services = NSMutableArray()
    var currPeripher:CBPeripheral?
    var channel:String = "perpheral"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        naviBtonTop.constant = naviXBtonTop
        naviHeight.constant = naviXBarHeight
        botmHeight.constant = 0
        
        tv_main.registerNibName(TCellBleroot.self)
        
        //初始化服务 准备链接设备
        self.services = NSMutableArray.init();
        SVProgressHUD.showInfo(withStatus: "准备连接设备")

        // Do any additional setup after loading the view.
    }
    
    //返回操作响应
    @IBAction func cancelAction(_ sender: Any) {
        
//        self.navigationController?.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isConnectedPeripherals() -> Bool {
        PrintFM("")
        
        return true
    }
    
    func chuanzhi(currentPeripheral:CBPeripheral) -> Void {
//        PrintFM(currentPeripheral)
//        BLEM.currPeripher  = currentPeripheral
        //连接外设
//        BLEM.manager.connectToPeripheral(withChannel: BLEM.channel, peripheral: currentPeripheral)
        
        BLEM.managerValuePer()
        
        BLEM.manager.xm_discoverServices { (peripheral, error) in
            for s:CBService in (peripheral?.services)! {
                self.insertSectionToTableView(service: s)
            }
        }
        BLEM.manager.xm_xmDiscoverCharacteristics(atChannel: { (peripheral, service, error) in
            self.insertRowToTableView(service: service!)
        })
        
//        BLEM.manager.xm_readValueForCharacter { (peripheral, characteristics, error) in
//            
//        }
//        BLEM.manager.xm_readValueForDescriptors { (peripheral, descriptor, error) in
//            
//        }
//        BLEM.manager.xm_discoverDescriptorsForCharacteristic { (peripheral, characteristics, error) in
//
//        }
//        BLEM.manager.xm_disconnect { (central, peripheral, error) in
//            SVProgressHUD.showError(withStatus: "peripheral Services 已经断开连接，请重新连接")
//        }
//        BLEM.manager.xm_connectState { (state) in
//            PrintFM(state)
//            if state{
//                SVProgressHUD.showSuccess(withStatus: "peripheral Services 连接成功");
//            }else{
//                SVProgressHUD.showError(withStatus: "peripheral Services 已经断开连接，请重新连接")
//            }
//        }
    }
    
    func insertSectionToTableView(service:CBService) -> Void {
        PrintFM( service.uuid.uuidString)
        let info = XMPeripheralInfo.init()
        info.serviceUUID = service.uuid
        self.services.add(info)
        let indexSet = NSIndexSet.init(index: self.services.count - 1)
        self.tv_main.insertSections(indexSet as IndexSet, with: .automatic)
    }
    func insertRowToTableView(service:CBService) -> Void{
        var sect:Int = -1
        
        for (index,item) in self.services.enumerated() {
            if ((item as! XMPeripheralInfo).serviceUUID == service.uuid) {
                sect = index;
            }
        }
        
        if sect != -1 {
            let info = self.services.object(at: sect) as! XMPeripheralInfo
            
            for (index,item) in (service.characteristics?.enumerated())! {
                info.characteristics.add(item as CBCharacteristic)
                let indexPath = NSIndexPath.init(row: index, section: sect)
                self.tv_main.insertRows(at: [indexPath as IndexPath], with: .automatic)
            }
            
        }
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

extension BLEServicesVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.services.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.services.object(at: section) as! XMPeripheralInfo
        return info.characteristics.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellBleroot", for: indexPath) as! TCellBleroot
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //服务特性
        
        let info = self.services.object(at: indexPath.section) as! XMPeripheralInfo
        let characteristic = info.characteristics.object(at: indexPath.row) as! CBCharacteristic
        
        cell.label_des.text = "服务特性"
        cell.label_subtitle.text = String.init(format: "%@", characteristic.uuid.uuidString)
        
        let value:(String,Bool) = getCharacterDes(characteristic.properties)
        cell.label_title.text = value.0
        
        cell.backgroundColor = value.1 ? UIColor.white:UIColor.lightGray
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 68
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //    服务UUID分类。
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        let info = self.services.object(at: section) as! XMPeripheralInfo
        label.text = String.init(format: "UUID： %@", info.serviceUUID)
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //服务特性
        
        let info = self.services.object(at: indexPath.section) as! XMPeripheralInfo
        let characteristic = info.characteristics.object(at: indexPath.row) as! CBCharacteristic
        let value:(String,Bool) = getCharacterDes(characteristic.properties)
        
        if value.1{
            PrintFM("\(indexPath.row)")
            BLEM.characteristic = characteristic
            
            BLEM.UDIDService = info.serviceUUID.uuidString
            BLEM.UDIDCharacteristic = characteristic.uuid.uuidString
            
            HUDShowMsgQuick("连接特性：\(characteristic.uuid.uuidString)", 0.8)
//            BLEM.managerValueCharacteristic()
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
