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
    var arrayOrders = [ModelOrderCreatePost]()
    
    //network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    let modelOrderListPost = ModelOrdersCreatePost()
    
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

    //MARK: 组装订单信息
    //店铺信息，商品信息，运费信息，收货地址信息（滞后）
    
    func combinOrderInfo() {
        
        arrayOrders.removeAll()
        
        for i in 0..<arrayMain.count {
            
            let CarSectionContent = arrayMain[i] as! ModelShoppingCarProducts
            
            let modelOrderC = ModelOrderCreatePost()
            
            //组合订单   基本信息
            modelOrderC.companyId = PARTNERID_SHOP
            modelOrderC.shopId = CarSectionContent.linkId
            modelOrderC.shopName = ""
            modelOrderC.userId = USERM.MemberID
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
            
            //组合订单   地址信息
            if addressValue {
                modelOrderC.userName = model_address.receiverName!
                modelOrderC.phone = model_address.receiverPhone!
                modelOrderC.address = (model_address.area ?? "请前往选择收货地址") + "" + (model_address.address ?? " ")
            }
            
            //组合订单   商品信息
            var products = [OrderProductItemReq]()
            for item in CarSectionContent.products! {
                let modelproduct = OrderProductItemReq()
                modelproduct.productId = item.pid
                modelproduct.productName = item.name
                modelproduct.specification = item.specification
                modelproduct.number = item.productNumber
                modelproduct.price = item.finalPrice
                modelproduct.sequence = "0"
                products.append(modelproduct)
            }
            modelOrderC.products = products
            
            //组合订单   运费信息
            let modelaccount = OrderAccountItemReq()
            modelaccount.accountId = "20001"
            modelaccount.name = "运费"
            modelaccount.type = "1"
            modelaccount.price = 500
            modelaccount.number = "1"
            modelaccount.sequence = 0
            
            modelOrderC.accounts = [modelaccount]
            
            
            /*{}添加组合订单信息{}*/
            arrayOrders.append(modelOrderC)
            
        }
        
        modelOrderListPost.orders = arrayOrders
        
    }
    
    //MARK:提交订单
    
    func sendOrders() {
        
        
        if addressValue {
            
            OrderM.orderListCreate(amodel: modelOrderListPost)
                .subscribe(onNext: { (Result: ModelOrdersCreateBack) in
                    
                    PrintFM("Result\(String(describing: Result.data))")
                    
                    self.payAction(orderIDList: Result.data!)
                    
                },onError:{error in
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
            
//            self.payAction(orderIDList: ["84532482023620875","84532482076049676"])
            
        }else{
            HUDShowMsgQuick(msg: "请选择收货地址", toView: KeyWindow, time: 0.8)
        }
        
    }
    
    //支付
    
    /*
     
     "84532482023620875",
     "84532482076049676"
     
     */
    
    func payAction(orderIDList:[String]) {
        
        PrintFM("\(orderIDList)")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "pay_channelVC") as! pay_channelVC
        
        Vc.finalPrice = self.TotalPrice
        
        Vc.oidList = orderIDList
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
    
    @IBAction func actionPayNow(_ sender: Any) {
        
        sendOrders()
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
        
        combinOrderInfo()
        
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
