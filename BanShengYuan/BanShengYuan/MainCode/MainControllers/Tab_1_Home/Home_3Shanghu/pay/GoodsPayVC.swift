//
//  GoodsPayVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/29.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class GoodsPayVC: BaseTabHiden {
    
    //msg
    var model_goods:ModelShopDetailItem?              ///上上层商品数据
    var modelOrderC = ModelOrderCreatePost()           //上层订单model
    var modelOrderBack = ModelOrderCreateBackItem()   //oid上层订单返回model
    
    var totalPrice = Int()
    
    //network
    
    let OrderM = orderModel()
    let modelpayPost = ModelOrderPayPost()
    let disposeBag = DisposeBag()
    
    let VM = ViewModel()
    //data
    var array_address = NSMutableArray()
    
    @IBOutlet weak var tableV_main: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = FlatWhiteLight
        
        getTotalPrice()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
    }
    
    @IBAction func payNow(_ sender: Any) {
        
        payAction()
        
    }
    
    //支付
    
    func payAction() {
        
        if let oid = modelOrderBack.oid {
            let str = String(describing: oid)
            modelpayPost.orderId = str
        }
        
        modelpayPost.pay_ebcode = aliPay_ebcode
        
        OrderM.orderPay(amodel: modelpayPost)
            .subscribe(onNext: { (posts: modelPayPlanBack) in

                PrintFM("pictureList\(posts)")
                
                if let content = posts.data{
                    
                    PrintFM("content = \(content)")
                    
                    AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsy", callback: {(result) in
                        
                        HUDShowMsgQuick(msg: String(describing: result?.description), toView: self.view, time: 0.8)
                        
                        print("---\(String(describing: result?.description))")
                    })
                    
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
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "我的订单"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTotalPrice() {
        totalPrice = 0
        
        if let product = modelOrderC.products {
            let proitem = product[0]
            
            if let price = proitem.price {
                totalPrice += price
            }
            
        }
        
        if let product = modelOrderC.accounts {
            let proitem = product[0]
            
            if let price = proitem.price{
                totalPrice += price.intValue!
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension GoodsPayVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("View_payHeader", owner: nil, options: nil)?.first as? View_payHeader
        
        if let oid = modelOrderBack.oid {
            let str = String(describing: oid)
            viewheader?.label_orderid.text = str
        }
        
        viewheader?.label_name_phone.text = modelOrderBack.userName! + " " + modelOrderBack.phone!
        
        return viewheader
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let viewfooter = Bundle.main.loadNibNamed("View_payFooter", owner: nil, options: nil)?.first as? View_payFooter
        
        if let product = modelOrderC.accounts {
            let proitem = product[0]
            
            if let price = proitem.price{
                let str = String(describing: price)
                viewfooter?.label_yun.text = String.init("¥ \(String(describing: str.fixPrice()))")
            }
            
            let str_total = String(describing: totalPrice)
            viewfooter?.label_total.text = String.init("¥ \(String(describing: str_total.fixPrice()))")
        }
        
        
        
        return viewfooter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_UserOrder", for: indexPath) as! TCell_UserOrder
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let product = modelOrderC.products {
            let proitem = product[0] 
            cell.label_name.text = proitem.productName
            cell.lable_labels.text = proitem.specification
            
            if let price = proitem.price {
                let str = String(describing: price)
                cell.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
            }
            
            if let price = proitem.number {
                let str = String(describing: price)
                cell.lable_num.text = String.init("X \(str)")
            }
            
            if let picture = model_goods?.picture {
                let url = URL(string: picture)
                
                cell.imagev_sub.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
                    
                })

            }
            
        }
        
        return cell
        
    }
    
}

extension GoodsPayVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
