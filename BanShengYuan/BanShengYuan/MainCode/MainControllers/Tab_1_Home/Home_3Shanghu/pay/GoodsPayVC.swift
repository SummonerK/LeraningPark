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
//    input
    var model_goods:ModelShopDetailItem?              ///上上层商品数据
    var model_shop:ModelShopItem?                       ///上上上层商户数据
//    inview
    var modelOrderC = ModelOrderCreatePost()           //订单model
//    output
    var modelOrderBack = ModelOrderCreateBackItem()   //oid 提交下层支付使用
    
    var totalPrice = Int()
    
//network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    let modelpayPost = ModelOrderPayPost()
    let modeladdressset = ModelorderAddressSetPost()
    
    
    let VM = ViewModel()
    //data
    var array_address = NSMutableArray()
    
    //addressModel
    var model_address = ModelAddressItem()
    var addressValue:Bool = false
    
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
    
    //MARK:提交订单
    
    func sendOrder() {
        
        modelOrderC.companyId = model_goods?.companyId
        modelOrderC.shopId = PARTNERID_SHOP+"_"+(model_shop?.storeCode)!
        modelOrderC.shopName = model_shop?.storeName
        modelOrderC.userId = USERM.MemberID
        modelOrderC.userName = USERM.UserName
        modelOrderC.phone = USERM.Phone
        modelOrderC.address = "地址"
        modelOrderC.longitude = "121.377436"
        modelOrderC.latitude = "31.267283"
        modelOrderC.type = 1
        modelOrderC.status = 1
        modelOrderC.amount = 1490
        modelOrderC.payType = 1
        modelOrderC.payChannel = ""
        modelOrderC.payChannelName = ""
        modelOrderC.source = "ios app"
        modelOrderC.partition = ""
        modelOrderC.customerOrder = "BSY".OrderIDFromtimeSP
        modelOrderC.remark = ""
        
        let modelproduct = OrderProductItemReq()
        modelproduct.productId = model_goods?.pid
        modelproduct.productName = model_goods?.name
        modelproduct.specification = "茶色 XL"
        modelproduct.number = "1"
        modelproduct.price = model_goods?.finalPrice
        modelproduct.sequence = "0"
        
        modelOrderC.products = [modelproduct]
        
        let modelaccount = OrderAccountItemReq()
        modelaccount.accountId = "account-1"
        modelaccount.name = "运费"
        modelaccount.type = "1"
        modelaccount.price = "500"
        modelaccount.number = "1"
        modelaccount.sequence = 0
        
        modelOrderC.accounts = [modelaccount]
        
        OrderM.orderCreate(amodel: modelOrderC)
            .subscribe(onNext: { (posts: ModelOrderCreateBack) in
                
                PrintFM("pictureList\(posts)")
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    //支付
    
    func payAction() {
        
        let biz_content = "app_id=2017071207729556&biz_content=%7b%22out_trade_no%22%3a%22SHT1A1553O1336740803%22%2c%22seller_id%22%3a%22%22%2c%22total_amount%22%3a%220.01%22%2c%22subject%22%3a%22%e5%8d%8a%e7%94%9f%e7%bc%98%22%2c%22goods_detail%22%3a%5b%7b%22goods_id%22%3a%221323%22%2c%22goods_name%22%3a%22%e6%9c%aa%e7%9f%a5%e5%95%86%e5%93%81%22%2c%22quantity%22%3a%221%22%2c%22price%22%3a%2299%22%7d%5d%2c%22store_id%22%3a%22107%22%7d&charset=utf-8&method=alipay.trade.app.pay&notify_url=http%3a%2f%2f115.159.142.32%2fapi%2falipaynotify%2f1553&prod_code=QUICK_MSECURITY_PAY&sign_type=RSA&timestamp=2017-07-14+09%3a39%3a12&version=1.0&sign=NUAMMvKtQdZj8Qrdl3wRqjoFgHk5gq8UlxH4o92Qn3FuO2cyunkve3wY5EbrAvuzvc1X4p5APlRKCnmat1rmzpxREsnTKxawL8HlQs4KESk4CIaRUJkyHnATuLCGbwagcHXuJnL8Pun4sY9hx4SAjmM6O7U%2faFi1Z9nrHJC6Rlc%3d"
        
        AlipaySDK.defaultService().payOrder(biz_content, fromScheme: "bsy", callback: {(result) in
            
            //            HUDShowMsgQuick(msg: String(describing: result?.description), toView: self.view, time: 0.8)
            
            print("---\(String(describing: result?.description))")
        })
        
//        if let oid = modelOrderBack.oid {
//            let str = String(describing: oid)
//            modelpayPost.orderId = str
//        }
//        
//        modelpayPost.pay_ebcode = aliPay_ebcode
//        
//        OrderM.orderPay(amodel: modelpayPost)
//            .subscribe(onNext: { (posts: modelPayPlanBack) in
//
//                PrintFM("pictureList\(posts)")
//                
//                if let content = posts.data{
//                    
//                    PrintFM("content = \(content)")
//                    
//                    AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsy", callback: {(result) in
//                        
//                        HUDShowMsgQuick(msg: String(describing: result?.description), toView: self.view, time: 0.8)
//                        
//                        print("---\(String(describing: result?.description))")
//                    })
//                    
//                }
//                
//            },onError:{error in
//                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
//                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
//                }else{
//                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
//                }
//            })
//            .addDisposableTo(disposeBag)
        
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
    
    //选择地址返回
    
    func BackAddress(item:ModelAddressItem) -> Void {
        
        
        /*
         
        if let oid = modelOrderBack.oid {
            let str = String(describing: oid)
            modeladdressset.orderId = str
        }
        
        OrderM.orderAddressSet(amodel: modeladdressset)
            .subscribe(onNext: { (posts: ModelorderAddressSetBack) in
                
                PrintFM("pictureList\(posts)")
                
//                if let content = posts.data{
//                    
//                    PrintFM("content = \(content)")
//                    
//                    
//                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        
        PrintFM("\(String(describing: item.toJSONString()))")
        
        */
        
        self.model_address = item
        
        self.tableV_main.reloadData()
    }
    
    func goAddressEditVC() {
        PrintFM("")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "AddressChooseVC") as! AddressChooseVC
        
        Vc.backValue = BackAddress(item:)
        
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("View_payHeader", owner: nil, options: nil)?.first as? View_payHeader
        
//        if let oid = modelOrderBack.oid {
//            let str = String(describing: oid)
//            viewheader?.label_orderid.text = str
//        }
        
        viewheader?.label_name_phone.text = (model_address.receiverName ?? "请皇上，选择收货人") + " " + (model_address.receiverPhone ?? " ")
        
        viewheader?.label_address.text = (model_address.area ?? "请皇上，选择收货地址") + "" + (model_address.address ?? " ")
        
        
        viewheader?.bton_adsEdit.addTarget(self, action: #selector(goAddressEditVC), for:UIControlEvents.touchUpInside)
        
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
        return 110
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
