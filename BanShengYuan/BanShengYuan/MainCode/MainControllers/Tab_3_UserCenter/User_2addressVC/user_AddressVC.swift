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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        tableV_main.register(UINib.init(nibName: "TCell_userAddress", bundle: nil), forCellReuseIdentifier: "TCell_userAddress")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
//        getData()
        
    }
    
    
    // Data 相关
    
    func getData(){
        
//        let address1 = ModelAddress()
//        address1.name = "君莫笑"
//        address1.phone = "15611112222"
//        address1.address_area = "上海 普陀"
//        address1.address_Detail = "祁连山路1888号 耀光国际B座 1803室"
//        address1.isFirst = true
//        
//        array_address.add(address1)

        
        let model_address = ModelAddressListPost()
        model_address.partnerId = PartNerID
        model_address.phone = "18915966899"
        VM.addressGetList(amodel: model_address)
            .subscribe(onNext: { (posts: [ModelAddressItem]) in
                PrintFM("log\(String(describing: posts.count))")
                
                self.array_address.removeAllObjects()
                
                self.array_address.addObjects(from: posts)
                
                self.tableV_main.reloadData()
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }

            })
            .addDisposableTo(disposeBag)
        
        
        
//        PrintFM(address1.toDict())
        
//        tableV_main.reloadData()
        
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
        Vc.tag_pagefrom = 1
        Vc.addressBack = {(model)  -> Void in
//            self.array_address.add(model)
//            self.tableV_main.reloadData()
        }
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
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
            
//            let model_address = ModelAddressUpdatePost()
//            model_address.partnerId = PartNerID
//            model_address.receiverName = (array_address[indexPath.section] as? ModelAddressItem)?.receiverName
//            model_address.phone = (array_address[indexPath.section] as? ModelAddressItem)?.phone
//            model_address.area = (array_address[indexPath.section] as? ModelAddressItem)?.area
//            model_address.address = (array_address[indexPath.section] as? ModelAddressItem)?.address
//            model_address.id = (array_address[indexPath.section] as? ModelAddressItem)?.id
//            VM.addressUpdate(amodel: model_address)
//                .subscribe(onNext: {(common:ModelCommonBack) in
//                    PrintFM("设置默认\(String(describing: common.description))")
//                    
//                    self.array_address.removeObject(at: indexPath.section)
//                    self.tableV_main.reloadData()
//                    
//                },onError:{error in
//                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
//                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
//                    }else{
//                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
//                    }
//                    
//                })
//                .addDisposableTo(disposeBag)
  
        case .EDIT:
            PrintFM("edit\(indexPath)")
            //添加地址页面
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_addressAddVC") as! user_addressAddVC
            Vc.tag_pagefrom = 2
            Vc.modelEdit = array_address[indexPath.section] as? ModelAddressItem
            
//            Vc.addressBack = {(model)  -> Void in
//                self.array_address[indexPath.section] = model
//                self.tableV_main.reloadData()
//            }
            
            self.navigationController?.pushViewController(Vc, animated: true)
        case .DELETE:
            
            let temp = (array_address[indexPath.section] as? ModelAddressItem)
            
            let model_address = ModelAddressDeletePost()
            model_address.partnerId = PartNerID
            model_address.phone = "18915966899"
            model_address.id = temp?.id
            VM.addressDelete(amodel: model_address)
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
                .addDisposableTo(disposeBag)
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
