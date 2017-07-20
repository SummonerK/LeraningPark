//
//  Home_pShanghu.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import MJRefresh

let Pagesize:Int = 10

class Home_pShanghu: BaseTabHiden {
    
    //network
    
    let VipM = vipModel()
    let modellistPost = ModelShopListPost()
    let disposeBag = DisposeBag()
    
    //data
    var array_items = NSMutableArray()

    //layoutView
    @IBOutlet weak var tableV_main: UITableView!
    
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var Num:Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCellshanghu", bundle: nil), forCellReuseIdentifier: "TCellshanghu")
        
        // 上拉刷新
//        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
//        tableV_main.mj_footer = footer
        
        getData()

    }
    
    func footerRefresh(){
        print("上拉加载更多")
        
        self.tableV_main.mj_footer.resetNoMoreData()
        
        Num += 1
        
        modellistPost.pageSize = Pagesize
        modellistPost.pageNo = Num
        
        VipM.vipgetShopList(amodel: modellistPost)
            .subscribe(onNext: { (posts: [ModelShopItem]) in
                
                if posts.count < Pagesize{
                    self.Num -= 1
                    self.tableV_main.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tableV_main.mj_footer.endRefreshing()
                }
                
                self.array_items.addObjects(from: posts)
                
                self.tableV_main.reloadData()
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    if (error as? MyErrorEnum)?.drawCodeValue != 999{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }
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
        self.navigationItem.title = "商铺列表"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        
        modellistPost.op = "getShopList"
        modellistPost.partnerId = PARTNERID_SHOP
        modellistPost.pageSize = Pagesize
        modellistPost.pageNo = Num

        VipM.vipgetShopList(amodel: modellistPost)
            .subscribe(onNext: { (posts: [ModelShopItem]) in
                
                self.array_items.removeAllObjects()
                
                self.array_items.addObjects(from: posts)
                
                self.tableV_main.reloadData()
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    
}

extension Home_pShanghu:UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
//        
//        PrintFM("")
//        
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
//        return true
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

        return (section==0) ? IBScreenWidth*156/375 : 0

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    
        let imageArray = ["banner1","banner2","banner3"]
        
        let viewheader = view_shanghuHeader.init(frame: CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth*130/375))
        
        viewheader.isscroll = true
        
        viewheader.contentImages = {
            
            return imageArray
        }
        
        return viewheader
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return array_items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellshanghu", for: indexPath) as! TCellshanghu
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.setData(Model: array_items[indexPath.row] as! ModelShopItem)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension Home_pShanghu: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
//        return UITableViewCellEditingStyle.delete
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return IBScreenWidth*120/375
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        PrintFM("\((array_items[indexPath.row] as! ModelShopItem).description)")
        
        //品牌
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "shangHu_DetailVC") as! shangHu_DetailVC
        
        Vc.shopStoreCode = (array_items[indexPath.row] as! ModelShopItem).storeCode!
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
        PrintFM("\(indexPath.row)")
        
    }
}
