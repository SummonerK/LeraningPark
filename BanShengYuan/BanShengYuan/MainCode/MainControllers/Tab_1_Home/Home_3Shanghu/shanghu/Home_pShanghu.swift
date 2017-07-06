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

class Home_pShanghu: BaseTabHiden {
    
    //network
    
    let VipM = vipModel()
    let modellistPost = ModelShopListPost()
    let disposeBag = DisposeBag()
    
    //data
    var array_items = NSMutableArray()

    //layoutView
    @IBOutlet weak var tableV_main: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCellshanghu", bundle: nil), forCellReuseIdentifier: "TCellshanghu")
        
        getData()

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
        modellistPost.partnerId = PARTNERID
        modellistPost.pageSize = 10
        modellistPost.pageNo = 1

        VipM.vipgetShopList(amodel: modellistPost)
            .subscribe(onNext: { (posts: [ModelShopItem]) in
//                PrintFM("shopList\(posts)")
                
                self.array_items = posts as! NSMutableArray
                
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

        return (section==0) ? IBScreenWidth*156/375 : 0

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let imageArray = [
                    "http://wx3.sinaimg.cn/mw690/62eeaba5ly1fee5yt59wrj20fa08lafr.jpg",
                    "http://wx4.sinaimg.cn/mw690/6a624f11ly1fed4bwlbb0j20go0h6q5h.jpg",
                    "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                    "http://wx2.sinaimg.cn/mw690/af0d43ddgy1fdjzefvub1j20dw09q48s.jpg"
                ]
        
        let viewheader = view_shanghuHeader.init(frame: CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth*130/375))
        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return IBScreenWidth*120/375
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\((array_items[indexPath.row] as! ModelShopItem).description)")
        
        //品牌
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "shangHu_DetailVC") as! shangHu_DetailVC
        self.navigationController?.pushViewController(Vc, animated: true)
        
        PrintFM("\(indexPath.row)")
        
    }
}
