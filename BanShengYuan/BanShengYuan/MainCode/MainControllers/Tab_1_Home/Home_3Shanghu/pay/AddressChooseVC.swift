//
//  AddressChooseVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class AddressChooseVC: UIViewController {
    
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    
    //layoutView
    @IBOutlet weak var tableV_main: UITableView!
    
    //data
    var array_address = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCellPayAddress", bundle: nil), forCellReuseIdentifier: "TCellPayAddress")
        
        tableV_main.backgroundColor = FlatWhiteLight

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
        model_address.partnerId = PARTNERID
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
        self.navigationItem.title = "选择地址"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AddressChooseVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (array_address.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellPayAddress", for: indexPath) as! TCellPayAddress
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
}

extension AddressChooseVC: UITableViewDelegate {
    
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

