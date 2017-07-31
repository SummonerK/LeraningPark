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
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
        setOrderModel()
        
        getTotalPrice()
    }
    //MARK:整合订单数据
    @IBAction func payNow(_ sender: Any) {
        
        sendOrder()
        
    }
    
    func setOrderModel() {
        
        modelOrderC.companyId = model_goods?.companyId
        modelOrderC.shopId = PARTNERID_SHOP+"_"+(model_shop?.storeCode)!
        modelOrderC.shopName = model_shop?.storeName
        modelOrderC.userId = USERM.MemberID
        if addressValue {
            modelOrderC.userName = model_address.receiverName!
            modelOrderC.phone = model_address.receiverPhone!
            modelOrderC.address = (model_address.area ?? "请前往选择收货地址") + "" + (model_address.address ?? " ")
        }
//        modelOrderC.userName = USERM.UserName
//        modelOrderC.phone = USERM.Phone
//        modelOrderC.address = "地址"
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
        modelOrderC.remark = model_goods?.remark
        
        let modelproduct = OrderProductItemReq()
        modelproduct.productId = model_goods?.pid
        modelproduct.productName = model_goods?.name
        modelproduct.specification = model_goods?.specification
        modelproduct.number = model_goods?.productNumber
        modelproduct.price = model_goods?.finalPrice
//        modelproduct.price = 1
        modelproduct.sequence = "0"
        
        modelOrderC.products = [modelproduct]
        
        let modelaccount = OrderAccountItemReq()
        modelaccount.accountId = "20001"
        modelaccount.name = "运费"
        modelaccount.type = "1"
        modelaccount.price = "500"
//        modelaccount.price = "0"
        modelaccount.number = "1"
        modelaccount.sequence = 0
        
        modelOrderC.accounts = [modelaccount]
    }
    
    //MARK:提交订单
    
    func sendOrder() {
        
        if addressValue {

            OrderM.orderCreate(amodel: modelOrderC)
                .subscribe(onNext: { (posts: ModelOrderCreateBack) in

                    PrintFM("pictureList\(posts)")

                    if let modeldata = posts.data{
                        if let oid = modeldata.oid{
                            self.payAction(orderID: oid)
                        }
                    }

                },onError:{error in
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
            
//            self.payAction(orderID: 81610978848932101)
            
        }else{
            HUDShowMsgQuick(msg: "请选择收货地址", toView: KeyWindow, time: 0.8)
        }

    }
    
    //支付
    
    func payAction(orderID:Int) {
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "pay_channelVC") as! pay_channelVC
        
        Vc.finalPrice = self.totalPrice
        
        Vc.orderID = orderID
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
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
            
            if let price = proitem.price,let num = proitem.number{
                
                totalPrice += price * num
            }
            
        }
        
        if let product = modelOrderC.accounts {
            let proitem = product[0]
            
            if let price = proitem.price{
                totalPrice += price.intValue!
            }
        }
        
//        totalPrice = 1
        
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
        
        self.addressValue = true
        
        setOrderModel()
        
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
        
        viewheader?.label_name_phone.text = "请前往选择收货人"
        
        if let sectoryPhone = model_address.receiverPhone{
            viewheader?.label_name_phone.text = (model_address.receiverName ?? "请前往选择收货人") + " " + (sectoryPhone.sectoryPhone)
        }
        
        viewheader?.label_address.text = (model_address.area ?? "请前往选择收货地址") + "" + (model_address.address ?? " ")
        
        
        viewheader?.bton_adsEdit.addTarget(self, action: #selector(goAddressEditVC), for:UIControlEvents.touchUpInside)
        
        return viewheader
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let viewfooter = Bundle.main.loadNibNamed("View_payFooter", owner: nil, options: nil)?.first as? View_payFooter
        
        if let product = modelOrderC.accounts {
            let proitem = product[0]
            
            if let price = proitem.price{
                let str = String(describing: Int(price)!*Int(proitem.number!)!)
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
//            cell.lable_labels.text = proitem.specification
            
            let str = NSMutableString()
            
            if let sp = model_goods?.productNumber {
                
                str.append((model_goods?.remark ?? ""))
                str.append((model_goods?.specification ?? ""))
                str.append(" \(sp)")
                str.append((model_goods?.unit ?? ""))
                
                cell.lable_labels.text = str as String
            }
            
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
