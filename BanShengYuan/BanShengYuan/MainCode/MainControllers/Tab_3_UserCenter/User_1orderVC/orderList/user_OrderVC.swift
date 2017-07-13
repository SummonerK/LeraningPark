//
//  user_OrderVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class user_OrderVC: BaseTabHiden {
    
    //network
    let orderM = orderModel()
    let modelorderlistpost = ModelListPageByUserPost()
    let disposeBag = DisposeBag()
    
    var arrayOrderList = NSMutableArray()
    
    let modelPay = ModelOrderPayPost()
    
    @IBOutlet weak var tableV_main: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = FlatWhiteLight
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
        getOrderList()
        
//        getOrderPay()
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
    
    func getOrderList(){
        modelorderlistpost.userId = USERM.MemberID
        modelorderlistpost.pagesize = 30
        modelorderlistpost.pagenumber = 1
        
        orderM.orderListByUser(amodel: modelorderlistpost)
            .subscribe(onNext: { (posts: ModelOrderWithCount) in

                PrintFM("pictureList\(String(describing: posts.orders?.toJSONString()))")
                
                self.arrayOrderList.removeAllObjects()
                
                if let orders = posts.orders{
                    
                    self.arrayOrderList.addObjects(from: orders)
                    
                    self.tableV_main.reloadData()
                }

            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func getOrderPay(){
        modelPay.orderId = "80776216007672097"
        modelPay.pay_ebcode = aliPay_ebcode
        
        orderM.orderPay(amodel: modelPay)
            .subscribe(onNext: { (posts: modelPayPlanBack) in
                
                PrintFM("pictureList\(String(describing: posts.toJSONString()))")
                
                
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension user_OrderVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("view_orderHeader", owner: nil, options: nil)?.first as? view_orderHeader
        
        
        let order = arrayOrderList[section] as! ModelListPageByUserBack
        
        if let text = order.shopName {
            viewheader?.label_dianpuname.text = text
        }
        
        if let text = order.status {
            PrintFM("status = \(text)")
            switch text {
            case 2:
                viewheader?.label_wuliu.text = "待支付"
            case 3:
                viewheader?.label_wuliu.text = "待发货"
            case 4:
                viewheader?.label_wuliu.text = "配送中"
            default:
                viewheader?.label_wuliu.text = "系统处理中"
                break
            }
            
        }
        
//        viewheader?.label_dianpuname.text = "一家店铺"
//        viewheader?.label_wuliu.text = "已出库"
        
        return viewheader
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let viewfooter = Bundle.main.loadNibNamed("view_orderFooter", owner: nil, options: nil)?.first as? view_orderFooter
        
        let order = arrayOrderList[section] as! ModelListPageByUserBack
        
        var totalPrice = Int()
        
        totalPrice = 0
        
        if let product = order.products {
            let proitem = product[0]
            
            if let num = proitem.productNumber{
                
                viewfooter?.label_num.text = "共" + "\(num)" + "件商品"
                
                if let price = proitem.finalPrice{
                    
                    totalPrice = price*num
                }
                
            }
 
        }
        
//        if let product = order.accounts {
//            let proitem = product[0]
//            
//            if let price = proitem.price{
//                totalPrice += price
//            }
//        }
        
        let str_total = String(describing: totalPrice)
        
        PrintFM("str_total = \(str_total)")
        
        viewfooter?.label_price.text = String.init("¥ \(String(describing: str_total.fixPrice()))")
        
        return viewfooter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOrderList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_UserOrder", for: indexPath) as! TCell_UserOrder
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let order = arrayOrderList[indexPath.section] as! ModelListPageByUserBack
        
        if let products = order.products ,let model:ModelShopDetailItem = products[0]{
            
            if let suburl = model.picture {
                let url = URL(string: suburl)
                
                cell.imagev_sub.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            if let price = model.originalPrice {
                
                let str = String(describing: price)
                
                cell.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
                
            }
            
            if let text = model.name {
                cell.label_name.text = text
            }
            
            if let text = model.categoryName {
                cell.label_des.text = text
            }
            
            if let text = model.specification {
                cell.lable_labels.text = text
            }
            
            if let text = model.productNumber {
                cell.lable_num.text = "\(text)"
            }
            
        }
        
        return cell
        
    }
    
}

extension user_OrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 90
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
        //订单详情
        
//        let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
//        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}


