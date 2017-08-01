//
//  GoodsDetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class GoodsDetailVC: BaseTabHiden {
    
    //network
    
    let VipM = shopModel()
    let modelGoodsDetailPost = ModelGoodsDetailPost()
    let modelGoodsDetailPictruePost = ModelGoodsDetailPicturePost()
    
    let disposeBag = DisposeBag()
    
    var array_banner = NSMutableArray()
    
    let OrderM = orderModel()
    let modelOrderC = ModelOrderCreatePost()
    
    @IBOutlet weak var tableV_main: UITableView!
    
    let array_zDetail = ["zdetail1","zdetail2","zdetail3","zdetail4"]
    //长图
    let array_xDetail = NSMutableArray()
    let dic_HDetail = NSMutableDictionary()
    
    
    var coverVC: chooseVC! = nil
    
    var coverNVC: chooseNoneCoverVC! = nil
    
    var _tapGesture: UITapGestureRecognizer!
    
    var model_goods:ModelShopDetailItem? ///上层商品数据
    var model_shop:ModelShopItem? ///上上层商户数据
    
    var miMgheightdatas:[Int] = []
    
//    var isOpen:Bool? = false
    var isOpen:Bool? = true
    
    var didHight = NSMutableDictionary()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
 
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
        
        tableV_main.register(UINib.init(nibName: "TCellGoodsinfo", bundle: nil), forCellReuseIdentifier: "TCellGoodsinfo")
        tableV_main.register(UINib.init(nibName: "TCellGoodsImage", bundle: nil), forCellReuseIdentifier: "TCellGoodsImage")
        
        tableV_main.estimatedRowHeight = 200
        
//        tableV_main.rowHeight = UITableViewAutomaticDimension
        
        setCoverView()
        
        setCoverViewNone()
        
        getData()
        
    }
    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        PrintFM("")
    }
    
    func loadImagesHight(){
        
        
        if array_xDetail.count == 0 {
            return
        }
        
        for i in 0...array_xDetail.count-1{
            
            let key = "item"+"\(i)"
            
            dic_HDetail.setValue("0.01", forKey: key)
 
        }
        
        for i in 0...array_xDetail.count-1{
            
            let key = "item"+"\(i)"
            
            
            let url = URL(string: array_xDetail[i] as! String)
            let imageV = UIImageView.init()
            
            imageV.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
                
                let hight =  CGFloat( (image?.size.height)! / (image?.size.width)! * IBScreenWidth )
                
                self.dic_HDetail.setValue("\(hight)", forKey: key)
                
                self.tableV_main.reloadData()

            })
            
        }
    }
    
//    获取商品基本信息
    
    func getData(){
        
        modelGoodsDetailPost.productId = model_goods?.pid
        
        VipM.shopGetDetail(amodel: modelGoodsDetailPost)
            .subscribe(onNext: { (result: ModelGoodsDetailResult) in
                
                PrintFM("ModelGoodsDetailResult\(result)")
                
                if let detailText = result.detailText{
                    
                    PrintFM("array_itemPace = \(detailText.array_items)")
                    
                    self.array_xDetail.addObjects(from: detailText.array_items)
                    
                    self.loadImagesHight()
                    
                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        modelGoodsDetailPictruePost.productId = model_goods?.pid
        modelGoodsDetailPictruePost.type = "banner"
        
        VipM.shopGetDetailPictures(amodel: modelGoodsDetailPictruePost)
            .subscribe(onNext: { (posts: [ModelGoodsDetailResultPictures]) in
                
                PrintFM("pictureList\(posts)")
                
                self.array_banner.removeAllObjects()
                
                self.array_banner.addObjects(from: posts)
                
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

    
    func setCoverView(){
        
        coverVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "chooseVC") as? chooseVC
        
        coverVC.view.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenHeight)
        
        coverVC.delegate = self
        
        if let productid = model_goods?.pid {
            coverVC.getMeun(productid: productid)
        }
        
        if let picture = model_goods?.picture {
            let url = URL(string: picture)
            
            coverVC.imageVsub.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
                
            })
            
        }
        
        if let storeCode = model_shop?.storeCode{
            
            if storeCode == "107" {
                coverVC.label_kc.text = "库存1件"
            }else{
                coverVC.label_kc.text = "库存2件"
            }
            
        }
        
        if let price = model_goods?.finalPrice{
            
            let str = String(describing: price)
            
            coverVC.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
        }
        
        self.view.addSubview(coverVC.view)
        
        self.view.sendSubview(toBack: coverVC.view)
        
    }
    
    func showCoverView() {
        
//        HUDShowMsgQuick(msg: "敬请期待", toView: self.view, time: 0.8)
        
        coverVC.collection_main.reloadData()
        
        self.view.bringSubview(toFront: coverVC.view)
    }
    
    func closeCoverView() {
        
//        HUDShowMsgQuick(msg: "敬请期待", toView: self.view, time: 0.8)
        
        self.view.sendSubview(toBack: coverVC.view)
    }
    
    func setCoverViewNone(){
        
        coverNVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "chooseNoneCoverVC") as? chooseNoneCoverVC
        
        coverNVC.view.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenHeight)
        
        coverNVC.delegate = self
        
        self.view.addSubview(coverNVC.view)
        
        self.view.sendSubview(toBack: coverNVC.view)
        
    }
    
    func showCoverViewNone() {
        
        self.view.bringSubview(toFront: coverNVC.view)
    }
    
    func closeCoverViewNone() {
        
        self.view.sendSubview(toBack: coverNVC.view)
    }
    
    //提交订单
    @IBAction func buyNow(_ sender: Any) {
        
        let array = coverVC.dic_menuchoose.allValues as! [String]
        
        for item in array{
            
            if item == ""{
                
                showCoverViewNone()
//                HUDShowMsgQuick(msg: "请选择规格", toView: KeyWindow, time: 0.8)
                return
            }
            
        }
        
        let str = array.joined(separator: " ")
        model_goods?.remark = String(describing:str)
        model_goods?.productNumber = coverVC.proCount
        
        PrintFM("productID = \(coverVC.getChoosedGoodsID())")
        
        model_goods?.pid = "\(coverVC.getChoosedGoodsID())"
        
        goNextOrderV()
        
    }
    
//MARK:- 前往订单页
    func goNextOrderV() {
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
        Vc.model_shop = self.model_shop
        Vc.model_goods = self.model_goods
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension GoodsDetailVC:chooseNoneCoverVDelegate{
    
    func chooseNoneClose(){
        closeCoverViewNone()
    }
}

extension GoodsDetailVC:ChooseCoverVDelegate{
    
    func setAction(actionType:ChooseCoverActionType){
        switch actionType {
        case .ADD:
            PrintFM("")
        case .Fls:
            PrintFM("")
        case .CLOSE:
            PrintFM("")
            
            closeCoverView()
            
            let arraykeys = coverVC.dic_menuchoose.allKeys as! [String]
            
            let array = coverVC.dic_menuchoose.allValues as! [String]
            
            for item in array{
                
                if item == ""{
                    
//                    HUDShowMsgQuick(msg: "请选择规格", toView: KeyWindow, time: 0.8)
                    
                    return
                }
                
            }
            
            var strDis = String()
            
            for key in arraykeys{
                strDis.append(key.trueItemValue)
                strDis.append(":")
                strDis.append(coverVC.dic_menuchoose[key] as! String)
                strDis.append(" ")
            }
            
//            let str = array.joined(separator: " ")
//            model_goods?.remark = String(describing:str)
            
            model_goods?.remark = strDis
            model_goods?.productNumber = coverVC.proCount
            
            PrintFM("productID = \(coverVC.getChoosedGoodsID())")
            
            model_goods?.pid = "\(coverVC.getChoosedGoodsID())"
            
            self.tableV_main.reloadData()

        }
    }
    
    func buyNowAction(items:NSMutableDictionary,count:Int){
        
        PrintFM("myChoose \(items)")
        
        let arraykeys = items.allKeys as! [String]
        
        let array = items.allValues as! [String]

        for item in array{
            
            if item == ""{
//                HUDShowMsgQuick(msg: "请选择规格", toView: KeyWindow, time: 0.8)
                
                showCoverViewNone()
                
                return
            }
            
        }
        
        var strDis = String()
        
        for key in arraykeys{
            strDis.append(key.trueItemValue)
            strDis.append(":")
            strDis.append(coverVC.dic_menuchoose[key] as! String)
            strDis.append(" ")
        }
        
//            let str = array.joined(separator: " ")
//            model_goods?.remark = String(describing:str)
        
        model_goods?.remark = strDis
        model_goods?.productNumber = count
        
        closeCoverView()
        
        PrintFM("productID = \(coverVC.getChoosedGoodsID())")
        
        model_goods?.pid = "\(coverVC.getChoosedGoodsID())"

        self.tableV_main.reloadData()
        
        goNextOrderV()
    }
    
}

extension GoodsDetailVC:view_goodsMoreDelegate{
    func goodsMoreOpen(){
//        self.isOpen = true
//        self.tableV_main.reloadData()
    }
}

extension GoodsDetailVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 0{
            return IBScreenWidth
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        
        if section == 0 {
            
//            let imageArray = ["banner1","banner2","banner3"]
//            
//            let viewheader = view_shanghuHeader.init(frame: CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth*402/375))
//            
//            viewheader.isscroll = false
//            
//            viewheader.contentImages = {
//                
//                return imageArray
//            }
//            
//            return viewheader
            
            let viewHeader = Bundle.main.loadNibNamed("GoodsHeader", owner: nil, options: nil)?.first as? GoodsHeader
            
            if let picture = model_goods?.picture {
                let url = URL(string: picture)
                
                viewHeader?.imageV_header.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
                    
                })
                
            }
            

            return viewHeader
            
        }else{
            return nil
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            
            return array_xDetail.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsinfo", for: indexPath) as! TCellGoodsinfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.label_name.text = model_goods?.name

            if let price = model_goods?.finalPrice{

                let str = String(describing: price)
                
                cell.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
            }
            
            let str = NSMutableString()
            
            if let sp = model_goods?.productNumber {
                
                str.append((model_goods?.remark ?? ""))
//                str.append((model_goods?.specification ?? ""))
                str.append("\(sp)")
                str.append((model_goods?.unit ?? ""))
                
                cell.labelsp.text = str as String
            }
            
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsImage", for: indexPath) as! TCellGoodsImage
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let url = URL(string: array_xDetail[indexPath.row] as! String)
            
            cell.imageV_content.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in

                })
        
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}


extension GoodsDetailVC: TCellGoodsinfoDelegate {
    
    func setAction(actionType:String){
        showCoverView()
        
//        showCoverViewNone()
    }
    
    func GoodsinfoShowAction(actionType:String){
        self.isOpen = true
        self.tableV_main.reloadData()
    }
    
}

extension GoodsDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return 160 + 44
        case 2:
            
            if self.isOpen == true {
                
                let key = "item"+"\(indexPath.row)"
                
                let hight = dic_HDetail.value(forKey: key) as! String
                
                return  CGFloat(hight.floatValue!)
                
            }else{
                
                return 0.01
                
            }
            
//            return UITableViewAutomaticDimension
            
        default:
            return 0.01
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
