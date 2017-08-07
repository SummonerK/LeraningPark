//
//  order_continuePay.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/4.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class order_continuePay: UIViewController {
    
    @IBOutlet weak var tableV_main: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight

    }
    
    //MARK:整合订单数据
    @IBAction func payNow(_ sender: Any) {
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "继续支付"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension order_continuePay:UITableViewDataSource{
    
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
        
//        self.model_address = item
//        
//        self.addressValue = true
//        
//        setOrderModel()
        
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
//        
//        if let sectoryPhone = model_address.receiverPhone{
//            viewheader?.label_name_phone.text = (model_address.receiverName ?? "请前往选择收货人") + " " + (sectoryPhone.sectoryPhone)
//        }
//        
//        viewheader?.label_address.text = (model_address.area ?? "请前往选择收货地址") + "" + (model_address.address ?? " ")
//        
//        viewheader?.bton_adsEdit.addTarget(self, action: #selector(goAddressEditVC), for:UIControlEvents.touchUpInside)
        
        return viewheader
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let viewfooter = Bundle.main.loadNibNamed("View_payFooter", owner: nil, options: nil)?.first as? View_payFooter
        
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
        
        
        return cell
        
    }
    
}

extension order_continuePay: UITableViewDelegate {
    
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
