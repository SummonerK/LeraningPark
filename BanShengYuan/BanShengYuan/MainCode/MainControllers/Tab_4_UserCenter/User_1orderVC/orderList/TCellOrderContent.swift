//
//  TCellOrderContent.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/28.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import DZNEmptyDataSet

import MJRefresh

let MenuPagesize:Int = 20

class TCellOrderContent: UITableViewCell {

    //network
    let orderM = orderModel()
    let modelorderlistpost = ModelListPageByUserPost()
    let modelorderliststatuspost = ModelListPageByStatusPost()
    let disposeBag = DisposeBag()
    
    var arrayOrderList = NSMutableArray()
    
    @IBOutlet weak var tableV_main: UITableView!
    
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var Num:Int = 1
    
    var status:Int = 0
    
    //    下拉刷新
    let header = MJRefreshNormalHeader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2))
        
//        self.backgroundColor = AnyColor(alpha: 0.7)

        setContentView()

    }
    
    func setContentView(){
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableV_main.mj_footer = footer
        
        //下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(getOrderList))
        tableV_main.mj_header = header
        
        tableV_main.mj_footer.isAutomaticallyHidden = true
        
    }
    
    func setDefaultNoneData() {
        Num = 1
        self.arrayOrderList.removeAllObjects()
        self.tableV_main.mj_footer.resetNoMoreData()
        self.tableV_main.reloadData()
    }
    
    func getOrderList(){
        
        Num = 1
        self.tableV_main.mj_footer.resetNoMoreData()
        
        self.tableV_main.setContentOffset(CGPoint.zero, animated: false)
        
        switch status {
        case 0:
            modelorderlistpost.userId = USERM.MemberID
            modelorderlistpost.pagesize = MenuPagesize
            modelorderlistpost.pagenumber = Num
            
            orderM.orderListByUser(amodel: modelorderlistpost)
                .subscribe(onNext: { (posts: ModelOrderListResult) in
                    
                    self.arrayOrderList.removeAllObjects()
                    
                    if let data = posts.data,let orders = data.orders{
                        
                        self.tableV_main.mj_header.endRefreshing()
                        
                        self.arrayOrderList.addObjects(from: orders)
                        
                        self.tableV_main.reloadData()
                        
                    }
                    
                },onError:{error in
                    
                    self.tableV_main.mj_header.endRefreshing()
                    
                    if let acode = (error as? MyErrorEnum)?.drawCodeValue,acode == 2001{
                        HUDShowMsgQuick(msg: "暂无订单信息", toView: KeyWindow, time: 0.8)
                        return
                    }
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: KeyWindow, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: KeyWindow, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
            break
        case 3,4,5:
            modelorderliststatuspost.userId = USERM.MemberID
            modelorderliststatuspost.pagesize = MenuPagesize
            modelorderliststatuspost.pagenumber = Num
            modelorderliststatuspost.status = status
            
            orderM.orderListByStatus(amodel: modelorderliststatuspost)
                .subscribe(onNext: { (posts: ModelOrderListResult) in
                    
                    self.arrayOrderList.removeAllObjects()
                    
                    if let data = posts.data,let orders = data.orders{
                        
                        self.tableV_main.mj_header.endRefreshing()
                        
                        self.arrayOrderList.addObjects(from: orders)
                        
                        self.tableV_main.reloadData()
                        
                        if self.arrayOrderList.count > 0{
                            self.tableV_main.scrollsToTop = true
                        }
                        
                    }
                    
                },onError:{error in
                    
                    self.tableV_main.mj_header.endRefreshing()
                    
                    if let acode = (error as? MyErrorEnum)?.drawCodeValue,acode == 2001{
                        HUDShowMsgQuick(msg: "暂无订单信息", toView: KeyWindow, time: 0.8)
                        return
                    }
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: KeyWindow, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: KeyWindow, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
            break
        default:
            return
        }
        
    }
    
    func footerRefresh(){
        
        self.tableV_main.mj_footer.resetNoMoreData()
        
        Num += 1
        
        switch status {
        case 0:
            modelorderlistpost.userId = USERM.MemberID
            modelorderlistpost.pagesize = MenuPagesize
            modelorderlistpost.pagenumber = Num
            
            orderM.orderListByUser(amodel: modelorderlistpost)
                .subscribe(onNext: { (posts: ModelOrderListResult) in
                    
                    if let data = posts.data,let orders = data.orders{
                        
                        if orders.count < Pagesize{
                            self.Num -= 1
                            self.tableV_main.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            self.tableV_main.mj_footer.endRefreshing()
                        }
                        
                        self.arrayOrderList.addObjects(from: orders)
                        
                        self.tableV_main.reloadData()
                        
                        if self.arrayOrderList.count > 0{
                            self.tableV_main.scrollsToTop = true
                        }
                        
                    }
                    
                },onError:{error in
                    
                    self.tableV_main.mj_footer.endRefreshing()
                    
                    if let acode = (error as? MyErrorEnum)?.drawCodeValue,acode == 2001{
                        HUDShowMsgQuick(msg: "暂无订单信息", toView: KeyWindow, time: 0.8)
                        return
                    }
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: KeyWindow, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: KeyWindow, time: 0.8)
                    }
                    
                })
                .addDisposableTo(disposeBag)
            break
        case 2,3,4:
            
            modelorderliststatuspost.userId = USERM.MemberID
            modelorderliststatuspost.pagesize = MenuPagesize
            modelorderliststatuspost.pagenumber = Num
            modelorderliststatuspost.status = status
            
            orderM.orderListByStatus(amodel: modelorderliststatuspost)
                .subscribe(onNext: { (posts: ModelOrderListResult) in
                    
                    if let data = posts.data,let orders = data.orders{
                        
                        if orders.count < Pagesize{
                            self.Num -= 1
                            self.tableV_main.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            self.tableV_main.mj_footer.endRefreshing()
                        }
                        
                        self.arrayOrderList.addObjects(from: orders)
                        
                        self.tableV_main.reloadData()
                        
                        if self.arrayOrderList.count > 0{
                            self.tableV_main.scrollsToTop = true
                        }
                        
                    }
                    
                },onError:{error in
                    
                    self.tableV_main.mj_footer.endRefreshing()
                    
                    if let acode = (error as? MyErrorEnum)?.drawCodeValue,acode == 2001{
                        HUDShowMsgQuick(msg: "暂无订单信息", toView: KeyWindow, time: 0.8)
                        return
                    }
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: KeyWindow, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: KeyWindow, time: 0.8)
                    }
                    
                })
                .addDisposableTo(disposeBag)
            
            break
        default:
            return
        }
        
        
    }
    
}

extension TCellOrderContent:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("view_orderHeader", owner: nil, options: nil)?.first as? view_orderHeader
        
        let order = arrayOrderList[section] as! ModelListPageByUserBack
        
        if let text = order.shopName {
            viewheader?.label_dianpuname.text = text
        }
        
        if let text = order.status {
            PrintFM("status = \(text)")
            
            var str_orderStep = String()
            
            switch text {
            case 1:
                str_orderStep = "买家已付款"//下单
            case 2:
                str_orderStep = "订单待支付"
            case 3:
                str_orderStep = "商家待发货"//接单
            case 4:
                str_orderStep = "待收货"//配送中
            case 5:
                str_orderStep = "订单已完成"//完成
            case 6:
                str_orderStep = "订单取消"//取消
            default:
                str_orderStep = ""
                break
            }
            
            viewheader?.label_wuliu.text = str_orderStep
        }
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
        
        let str_total = String(describing: totalPrice)
        
//        PrintFM("str_total = \(str_total)")
        
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
                cell.lable_num.text = "X \(text)"
            }
            
        }
        
        return cell
        
    }
    
}

extension TCellOrderContent: UITableViewDelegate {
    
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


extension TCellOrderContent:DZNEmptyDataSetSource{
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat{
        return 10
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!{
        
        let text = "没有数据咯"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    //Add description/subtitle on empty dataset
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Get no more Data from Server, place check again!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //Add your image
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "item2_activity")
    }
    
}
