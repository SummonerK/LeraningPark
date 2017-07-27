//
//  CCellMenuContent.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/27.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import DZNEmptyDataSet

import MJRefresh

let MenuPagesize:Int = 20

class CCellMenuContent: UICollectionViewCell {
    
    //network
    let orderM = orderModel()
    let modelorderlistpost = ModelListPageByUserPost()
    let disposeBag = DisposeBag()
    
    var arrayOrderList = NSMutableArray()
    
    @IBOutlet weak var tableV_main: UITableView!
    
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var Num:Int = 1
    
    //    下拉刷新
    let header = MJRefreshNormalHeader()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = AnyColor(alpha: 0.7)
        
        setContentView()
        
        // Initialization code
    }
    
    func setContentView(){
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableV_main.mj_footer = footer
        
        //下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(getOrderList))
        tableV_main.mj_header = header

    }
    
    func getOrderList(){
        
        modelorderlistpost.userId = USERM.MemberID
        modelorderlistpost.pagesize = MenuPagesize
        modelorderlistpost.pagenumber = Num
        
        orderM.orderListByUser(amodel: modelorderlistpost)
            .subscribe(onNext: { (posts: ModelOrderWithCount) in
                
                PrintFM("pictureList\(String(describing: posts.orders?.toJSONString()))")
                
                self.arrayOrderList.removeAllObjects()
                
                if let orders = posts.orders{
                    
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
    }
    
    func footerRefresh(){
        
        self.tableV_main.mj_footer.resetNoMoreData()
        
        Num += 1
        
        modelorderlistpost.userId = USERM.MemberID
        modelorderlistpost.pagesize = MenuPagesize
        modelorderlistpost.pagenumber = Num
        
        orderM.orderListByUser(amodel: modelorderlistpost)
            .subscribe(onNext: { (posts: ModelOrderWithCount) in
                
                PrintFM("pictureList\(String(describing: posts.orders?.toJSONString()))")
                
                if let orders = posts.orders{
                    
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
    }

}

extension CCellMenuContent:UITableViewDataSource{
    
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
                cell.lable_num.text = "\(text)"
            }
            
        }
        
        return cell
        
    }
    
}

extension CCellMenuContent: UITableViewDelegate {
    
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


extension user_orderMenu:DZNEmptyDataSetSource{
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat{
        return 110
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!{
        
        let text = "没有数据咯"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    //Add description/subtitle on empty dataset
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Get no more Data from servicer, place check again!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //Add your image
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "item2_activity")
    }
    
    //Add your button
    
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        let str = "Add Grokkleglob"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    
    //Add action for button
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hurray", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
}

