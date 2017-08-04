//
//  shangHu_DetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import DZNEmptyDataSet

import MJRefresh

let SPPagesize:Int = 10

class shangHu_DetailVC: UIViewController {
    
    var shopStoreCode:String = ""
    
    var modelShop:ModelShopItem?
    
    var shopID:String?
    
    @IBOutlet weak var CV_main: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var Num:Int = 1
    
//    下拉刷新
    let header = MJRefreshNormalHeader()
    
    
    //network
    let VipM = shopModel()
    let VShopM = vipModel()
    let modelshopPost = ModelShopPost()
    let modelshopDetailPost = ModelShopDetailPost()
    let disposeBag = DisposeBag()
    
    //data
    var array_items = NSMutableArray()
    var sectionNum:Int? = 1
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FlatGrayLight
        
        setupCollection()
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        CV_main.mj_footer = footer
        
        //下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(getData))
        CV_main.mj_header = header
        
        
        if shopStoreCode != ""{
            
            modelshopPost.op = "getShop"
            modelshopPost.partnerId = PARTNERID_SHOP
            modelshopPost.storeCode = shopStoreCode
            modelshopPost.typeFlag = "3"
            
            VShopM.vipgetSignalShop(amodel: modelshopPost)
                .subscribe(onNext: { (posts: ModelShopBack) in
                    
                    self.modelShop = posts.data!
                    
                    self.getData()
                    
                    self.CV_main.mj_header.endRefreshing()
                    
                },onError:{error in
                    self.CV_main.mj_header.endRefreshing()
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(disposeBag)
        }
        
        
    }
    @IBAction func NaviBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NaviMenu(_ sender: Any) {
        
        PrintFM("meun")
        
    }
    
    func footerRefresh(){
        print("上拉加载更多")
        
        self.CV_main.mj_footer.resetNoMoreData()
        
        Num += 1
        
        modelshopDetailPost.pagesize = SPPagesize
        modelshopDetailPost.pagenumber = Num
        
        VipM.shopGetAllProducts(amodel: modelshopDetailPost)
            .subscribe(onNext: { (posts: [ModelShopDetailItem]) in
                
                if posts.count < Pagesize{
                    self.Num -= 1
                    self.CV_main.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.CV_main.mj_footer.endRefreshing()
                }
                
                self.array_items.addObjects(from: posts)
                
                self.CV_main.reloadData()
                
            },onError:{error in
                
                self.CV_main.mj_footer.endRefreshing()
                
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
    
    func getData() {
        
        if let storecode = modelShop?.storeCode{
            
            shopID = "\(PARTNERID_SHOP)_\(storecode)"
            
        }
        
        modelshopDetailPost.shopId = shopID
        modelshopDetailPost.pagesize = SPPagesize
        modelshopDetailPost.pagenumber = Num
        
        VipM.shopGetAllProducts(amodel: modelshopDetailPost)
            .subscribe(onNext: { (posts: [ModelShopDetailItem]) in
                
                self.array_items.addObjects(from: posts)
                
                self.CV_main.reloadData()
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func setupCollection() {
        

        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical

        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)

        flowLayout.minimumLineSpacing = 10

        flowLayout.minimumInteritemSpacing = 10
        
        CV_main.collectionViewLayout = flowLayout
        
        CV_main.register(UINib.init(nibName: "CCell_shhuDetail", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetail")
        
        CV_main.register(UINib.init(nibName: "CCell_shhuDetailHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CCell_shhuDetailHeader")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension shangHu_DetailVC:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        
        PrintFM("begin search")
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
    }
    
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    // 取消按钮触发事件
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 搜索内容置空
        PrintFM("\(String(describing: searchBar.text))")
        
        //搜索
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "shanghu_searchVC") as! shanghu_searchVC
        Vc.modelShop = self.modelShop
        Vc.shopID = shopID
        Vc.searchContent = searchBar.text
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
        searchBar.text = ""
        
        searchBar.resignFirstResponder()
    }
    
    
    
}

extension shangHu_DetailVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("\((array_items[indexPath.row] as! ModelShopDetailItem).description)")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        Vc.model_goods = array_items[indexPath.row] as? ModelShopDetailItem
        Vc.model_shop = self.modelShop
        Vc.shopID = shopID
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}

extension shangHu_DetailVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 110 + IBScreenWidth*180/375)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCell_shhuDetailHeader", for: indexPath) as! CCell_shhuDetailHeader
        
        if let businessImage = modelShop?.businessImages {
            
            for pagemodel in businessImage{
                
                if  let imageurl = pagemodel.imageUrl {
                    
                    let url = URL(string: imageurl)
                    
                    headerView.imageV_icon.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    break
                }
            }
        }
        
        if let name = modelShop?.storeName {
             headerView.label_shanghuName.text = name
        }
        
        if let storeCode = modelShop?.storeCode {
            if storeCode == "001" {
                headerView.imageV_light.image = BundleImageWithName("subactivity2")
            }else{
                headerView.imageV_light.image = BundleImageWithName("hbright2")
            }
        }

        headerView.layoutIfNeeded()
        
        return headerView
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return sectionNum!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return array_items.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetail", for: indexPath) as! CCell_shhuDetail
        
        cell.setData(Model: array_items[indexPath.row] as! ModelShopDetailItem)
        
        return cell
        
    }
    
    
}

extension shangHu_DetailVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numPreRow = 2
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        return CGSize.init(width: ItemW, height: Int(Double(ItemW)*1.1)+52)
    }
    
}

extension shangHu_DetailVC:DZNEmptyDataSetSource{
    
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
        let str = "Get no more Data from Server, place check again!"
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
