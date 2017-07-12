//
//  user_AddressVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import SwiftyJSON

class user_AddressVC: BaseTabHiden {
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()

    //layoutView
    @IBOutlet weak var tableV_main: UITableView!
    
    //data
    var array_address = NSMutableArray()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        getData()
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "payNotifation"), object: nil)
    }
    
    //通知内容接收
    func action(notification: NSNotification) {
        
        let dict = notification.userInfo
        
        PrintFM("通知\(String(describing: dict))")
        
        PrintFM("\(String(describing: dict?["key"]))")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(action(notification:)), name: NSNotification.Name(rawValue: "payNotifation"), object: nil)
        
        setNavi()

        tableV_main.register(UINib.init(nibName: "TCell_userAddress", bundle: nil), forCellReuseIdentifier: "TCell_userAddress")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
//        getData()
        
    }
    
    //默认地址处理
    func setDefaultAddress(array:NSMutableArray){
        
        let arraytemp = NSMutableArray()
        
        arraytemp.addObjects(from: array as! [Any])
        
        array.removeAllObjects()
        
        for item in arraytemp {
            if (item as! ModelAddressItem).isDefault == 0{
                array.add(item)
            }else{
                array.insert(item, at: 0)
            }
        }
    }
    
    
    // Data 相关
    
    func getData(){
        
        let model_address = ModelAddressListPost()
        model_address.partnerId = PartNerID
        model_address.phone = USERM.Phone
        VM.addressGetList(amodel: model_address)
            .subscribe(onNext: { (posts: [ModelAddressItem]) in
                PrintFM("log\(String(describing: posts.count))")
                
                self.array_address.removeAllObjects()
                
                self.array_address.addObjects(from: posts)
                
                self.setDefaultAddress(array: self.array_address)
                
                self.tableV_main.reloadData()
                
            },onError:{error in
                
                if let acode = (error as? MyErrorEnum)?.drawCodeValue,acode == 2001{
                    HUDShowMsgQuick(msg: "暂无地址信息", toView: self.view, time: 0.8)
                    return
                }
                
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }

            })
            .addDisposableTo(disposeBag)
        
    }
    
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "收货地址"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddAction(_ sender: Any) {
        //添加地址页面
        let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_addressAddVC") as! user_addressAddVC
        
//        Vc.BadBack = badBack(name:)

        Vc.tag_pagefrom = 1
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
    func badBack(name:String) -> Void {
        PrintFM("\(name)")
//        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension user_AddressVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (array_address.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_userAddress", for: indexPath) as! TCell_userAddress
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.delegate = self
        cell.addressIndex = indexPath
        cell.setModel(toModel: (array_address[indexPath.section] as? ModelAddressItem)!)
        
        if (array_address[indexPath.section] as! ModelAddressItem).isDefault  == 1 {
            cell.bton_set.isSelected = true
        }else{
            cell.bton_set.isSelected = false
        }
        
        return cell
    }
    
}


extension user_AddressVC: UserAddressDelegate{
    
    func setAction(indexPath:IndexPath, actionType:AddressActionType){
        switch actionType {
        case .SET:
            PrintFM("set\(indexPath)")
            
            let model_address = ModelAddressUpdatePost()
            model_address.partnerId = PartNerID
            model_address.receiverName = (array_address[indexPath.section] as? ModelAddressItem)?.receiverName
            model_address.receiverPhone = (array_address[indexPath.section] as? ModelAddressItem)?.receiverPhone
            model_address.phone = (array_address[indexPath.section] as? ModelAddressItem)?.phone
            model_address.area = (array_address[indexPath.section] as? ModelAddressItem)?.area
            model_address.address = (array_address[indexPath.section] as? ModelAddressItem)?.address
            model_address.id = (array_address[indexPath.section] as? ModelAddressItem)?.id
            model_address.isDefault = 1
            VM.addressUpdate(amodel: model_address)
                .subscribe(onNext: {(common:ModelCommonBack) in
                    PrintFM("设置默认\(String(describing: common.description))")
                    
                    for item in self.array_address{
                        (item as! ModelAddressItem).isDefault = 0
                    }
                    
                    (self.array_address[indexPath.section] as? ModelAddressItem)?.isDefault = 1
                    
                    self.setDefaultAddress(array: self.array_address)
                    
                    self.tableV_main.reloadData()
                    
                },onError:{error in
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                    
                })
                .addDisposableTo(disposeBag)
  
        case .EDIT:
            PrintFM("edit\(indexPath)")
            //添加地址页面
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_addressAddVC") as! user_addressAddVC
            Vc.tag_pagefrom = 2
            Vc.modelEdit = array_address[indexPath.section] as? ModelAddressItem
            
            self.navigationController?.pushViewController(Vc, animated: true)
        case .DELETE:
            
            let alert = UIAlertController(title: "提示", message: "删除数据将不可恢复", preferredStyle: .alert)
            
            let calcelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "删除", style: .default, handler: { (UIAlertAction) in
                
                let temp = (self.array_address[indexPath.section] as? ModelAddressItem)
                
                let model_address = ModelAddressDeletePost()
                model_address.partnerId = PartNerID
                model_address.phone = USERM.Phone
                model_address.id = temp?.id
                self.VM.addressDelete(amodel: model_address)
                    .subscribe(onNext: {(common:ModelCommonBack) in
                        PrintFM("删除\(String(describing: common.description))")
                        
                        self.array_address.remove(self.array_address[indexPath.section])
                        self.tableV_main.reloadData()
                        
                    },onError:{error in
                        if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                            HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                        }else{
                            HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                        }
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
            })
            
            // 添加
            alert.addAction(calcelAction)
            alert.addAction(deleteAction)
            
            // 弹出
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
}

extension user_AddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 95
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
