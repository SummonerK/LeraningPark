//
//  user_AddressVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_AddressVC: BaseTabHiden {

    @IBOutlet weak var tableV_main: UITableView!
    
    let array_address = NSMutableArray()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        tableV_main.register(UINib.init(nibName: "TCell_userAddress", bundle: nil), forCellReuseIdentifier: "TCell_userAddress")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
        getData()
        
    }
    
    
    // Data 相关
    
    func getData(){
        
        let address1 = ModelAddress()
        address1.name = "君莫笑"
        address1.phone = "15611112222"
        address1.address_area = "上海 普陀"
        address1.address_Detail = "祁连山路1888号 耀光国际B座 1803室"
        address1.isFirst = true
        
        array_address.add(address1)
        
//        PrintFM(address1.toDict())
        
        tableV_main.reloadData()
        
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
            self.array_address.add(model)
            self.tableV_main.reloadData()
        }
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func getBack(_ back:ModelAddress,_ page:Int) -> Void{
//        
//        PrintFM("\(back.toDict()) --- from page \(page)")
//        
//    }
    
//    func checkModelsInArray(){
//        
//        let array_temp = NSMutableArray(array: array_address as! [ModelAddress], copyItems: true)
//        
//        for I in 0...array_temp.count {
//            if (array_temp[I] as! ModelAddress).isFirst{
//                array_address.insert(array_temp[I], at: 0)
//            }else{
//                array_address.add(array_temp[I])
//            }
//
//        }
//        
//    }
    
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
        cell.setModel(toModel: (array_address[indexPath.section] as? ModelAddress)!)
        
        if (array_address[indexPath.section] as! ModelAddress).isFirst {
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
            
//            for I in 0...self.array_address.count {
//                (self.array_address[I] as? ModelAddress)?.isFirst = false
//            }
//            
//            let model = self.array_address[indexPath.section] as! ModelAddress
//            model.isFirst = true
//            
//            self.array_address.removeObject(at: indexPath.section)
//            self.array_address.insert(model, at: 0)
//            
//            self.tableV_main.reloadData()
            
            
        case .EDIT:
            PrintFM("edit\(indexPath)")
            //添加地址页面
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_addressAddVC") as! user_addressAddVC
            Vc.tag_pagefrom = 2
            Vc.modelEdit = array_address[indexPath.section] as? ModelAddress
            Vc.addressBack = {(model)  -> Void in
                self.array_address[indexPath.section] = model
                self.tableV_main.reloadData()
            }
            self.navigationController?.pushViewController(Vc, animated: true)
        case .DELETE:
            self.array_address.removeObject(at: indexPath.section)
            self.tableV_main.reloadData()
            PrintFM("delete\(indexPath)")
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
