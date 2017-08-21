//
//  ShoppingCarPayVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class ShoppingCarPayVC: UIViewController {
    
    var arrayMain = NSMutableArray()
    
    //network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    let modelpayPost = ModelOrderPayPost()
    
    //addressModel
    var model_address = ModelAddressItem()
    var addressValue:Bool = false
    
    @IBOutlet weak var tableV_main: UITableView!
    
    @IBOutlet weak var label_totalprice: UILabel!
    
    var TotalPrice:Int = 0{
        willSet{
            
        }
        didSet{
            let str = String(describing: TotalPrice)
            label_totalprice.text = String.init("¥ \(String(describing: str.fixPrice()))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
        // 底部分割线左对齐
        
//        tableV_main.separatorInset = UIEdgeInsets.zero
//        
//        tableV_main.layoutMargins = UIEdgeInsets.zero
        
        fixTotalPrice()

    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "我的订单"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fixTotalPrice(){
        
        var totalPrice:Int = 0
        
        for i in 0..<arrayMain.count {
            let products = arrayMain[i] as! ModelShoppingCarProducts
            for item in products.products! {
                if item.chooseFlag == true{
                    totalPrice = totalPrice + (item.finalPrice! * item.productNumber!)
                }else{
                    continue
                }
            }
            
            //添加运费
            
            totalPrice = totalPrice + 500
        }
        
        TotalPrice = totalPrice
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ShoppingCarPayVC:UITableViewDataSource{
    
    //选择地址返回
    
    func BackAddress(item:ModelAddressItem) -> Void {
        
        self.model_address = item
        
        self.addressValue = true
        
        self.tableV_main.reloadData()
    }
    
    func goAddressEditVC() {
        PrintFM("")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "AddressChooseVC") as! AddressChooseVC
        
        Vc.backValue = BackAddress(item:)
        
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if section == 0 {
            let viewheader = Bundle.main.loadNibNamed("View_payHeader", owner: nil, options: nil)?.first as? View_payHeader
            
            viewheader?.label_name_phone.text = "请前往选择收货人"
            
            if let sectoryPhone = model_address.receiverPhone{
                viewheader?.label_name_phone.text = (model_address.receiverName ?? "请前往选择收货人") + " " + (sectoryPhone.sectoryPhone)
            }
            
            viewheader?.label_address.text = (model_address.area ?? "请前往选择收货地址") + "" + (model_address.address ?? " ")
            
            
            viewheader?.bton_adsEdit.addTarget(self, action: #selector(goAddressEditVC), for:UIControlEvents.touchUpInside)
            
            return viewheader
        }else{
            
            let viewheader = Bundle.main.loadNibNamed("ViewShoppingPayHeader", owner: nil, options: nil)?.first as? ViewShoppingPayHeader
            
            return viewheader
            
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        if section != 0 {
            let viewfooter = Bundle.main.loadNibNamed("View_payFooter", owner: nil, options: nil)?.first as? View_payFooter
            
            var totalPrice:Int = 0
            
            let products = arrayMain[section-1] as! ModelShoppingCarProducts
            for item in products.products! {
                if item.chooseFlag == true{
                    totalPrice = totalPrice + (item.finalPrice! * item.productNumber!)
                }else{
                    continue
                }
            }
            
            //添加运费
            
            totalPrice = totalPrice + 500
            
            viewfooter?.TotalPrice = totalPrice
            viewfooter?.transPrice = 500
            
            return viewfooter
        }else{
            return nil
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayMain.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else{
            
            let products = arrayMain[section-1] as! ModelShoppingCarProducts
            
            return (products.products?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_UserOrder", for: indexPath) as! TCell_UserOrder
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let products = arrayMain[indexPath.section-1] as! ModelShoppingCarProducts
        
        if let product = products.products?[indexPath.row] {
            cell.setContent(product: product)
        }
        
        return cell
        
    }
    
}

extension ShoppingCarPayVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 0 {
            return 110
        }else{
            return 44
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        if section != 0 {
            return 72
        }else{
            return 0.1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
