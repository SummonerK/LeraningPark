//
//  shanghu_searchVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/20.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import MJRefresh

class shanghu_searchVC: UIViewController,SearchSHHolderDelegate,shhuDetailHeaderDelegate{
    
    var modelShop:ModelShopItem?
    
    var shopID:String?
    var searchContent:String?
    
    var sectionNum:Int? = 1
    
    var numPreRow = 2
    
    @IBOutlet weak var CV_main: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var searchCoverVC: searchSHHolderVC! = nil
    
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var Num:Int = 1
    //    下拉刷新
    let header = MJRefreshNormalHeader()
    
    //network
    let VipM = shopModel()
    let modelsearchPost = ModelSearchProductPost()
    let disposeBag = DisposeBag()
    
    var array_items = NSMutableArray()
    
    var array_sort = [("saleCount",1),("finalPrice",1),("pid",1)]
    var sortIndex = 0{
        willSet{
            
        }
        didSet{
            
            if oldValue == sortIndex {
                PrintFM("sortIndex = \(sortIndex)")
                getIndexData()
            }else{
                getData()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FlatGrayLight
        
        searchbar.text = searchContent
        
        setupCollection()
        
        SetSearchCoverHolderV()
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        CV_main.mj_footer = footer
        
        //下拉刷新
        
        header.setRefreshingTarget(self, refreshingAction: #selector(getData))
        CV_main.mj_header = header
        
        getData()
        
        // Do any additional setup after loading the view.
    }
    
    func SetSearchCoverHolderV(){
        
        searchCoverVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "searchSHHolderVC") as? searchSHHolderVC
        
        searchCoverVC.view.frame = CGRect.init(x: 0, y: 64, width: IBScreenWidth, height: IBScreenHeight-64)
        
        searchCoverVC.delegate = self
        
        self.view.addSubview(searchCoverVC.view)
        
        openSearchHolder(isOpen: true)
    }
    //预留，标签搜索。。。。
    func SearchContent(content:String){
        searchContent = content
        searchbar.text = content
        getData()
        searchbar.resignFirstResponder()
    }
    
    func openSearchHolder(isOpen:Bool) {
        
        if isOpen {
            self.view.bringSubview(toFront: searchCoverVC.view)
        }else{
            self.view.sendSubview(toBack: searchCoverVC.view)
        }
        
    }
    
    
    @IBAction func NaviBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func NaviMenu(_ sender: Any) {
        
        PrintFM("meun")
        
        numPreRow = numPreRow == 1 ? 2 : 1
        self.CV_main.reloadData()

    }
    
    func getData() {
        
        self.CV_main.mj_footer.resetNoMoreData()
        
        Num = 1
        
        modelsearchPost.productName = searchContent
        modelsearchPost.shopId = shopID
        modelsearchPost.pagesize = SPPagesize
        modelsearchPost.pagenumber = Num
        modelsearchPost.sortName = array_sort[sortIndex].0
        modelsearchPost.sortOrder = array_sort[sortIndex].1
        
        if searchContent != "" {
            VipM.shopSearchProducts(amodel: modelsearchPost)
                .subscribe(onNext: { (posts: ModelSearchProductResult) in
                    
                    self.CV_main.mj_header.endRefreshing()
                    
                    self.array_items.removeAllObjects()
                    
                    if let data = posts.data,let products = data.products{
                        self.array_items.addObjects(from: products)
                        self.CV_main.reloadData()
                        
                        if self.array_items.count == 0{
                            self.openSearchHolder(isOpen: true)
                        }else{
                            self.openSearchHolder(isOpen: false)
                        }
                        
                    }
                    
                },onError:{error in
                    
                    self.CV_main.mj_header.endRefreshing()
                    
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
    }
    
    func getIndexData() {
        
        self.CV_main.mj_footer.resetNoMoreData()
        
        Num = 1
        
        modelsearchPost.productName = searchContent
        modelsearchPost.shopId = shopID
        modelsearchPost.pagesize = SPPagesize
        modelsearchPost.pagenumber = Num
        modelsearchPost.sortName = array_sort[sortIndex].0
        
        if array_sort[sortIndex].1 == 1{
            array_sort[sortIndex].1 = 2
        }else{
            array_sort[sortIndex].1 = 1
        }
        
        modelsearchPost.sortOrder = array_sort[sortIndex].1
        
        if searchContent != "" {
            VipM.shopSearchProducts(amodel: modelsearchPost)
                .subscribe(onNext: { (posts: ModelSearchProductResult) in
                    
                    self.CV_main.mj_header.endRefreshing()
                    
                    self.array_items.removeAllObjects()
                    
                    if let data = posts.data,let products = data.products{
                        self.array_items.addObjects(from: products)
                        self.CV_main.reloadData()
                        
                        if self.array_items.count == 0{
                            self.openSearchHolder(isOpen: true)
                        }else{
                            self.openSearchHolder(isOpen: false)
                        }
                        
                    }
                    
                },onError:{error in
                    
                    self.CV_main.mj_header.endRefreshing()
                    
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
    }
    
    func footerRefresh() {
        self.CV_main.mj_footer.resetNoMoreData()
        
        Num += 1
        
        modelsearchPost.productName = searchContent
        modelsearchPost.pagesize = SPPagesize
        modelsearchPost.pagenumber = Num
        modelsearchPost.sortName = array_sort[sortIndex].0
        modelsearchPost.sortOrder = array_sort[sortIndex].1
        
        if searchContent != "" {
            VipM.shopSearchProducts(amodel: modelsearchPost)
                .subscribe(onNext: { (posts: ModelSearchProductResult) in
                    
                    if let data = posts.data,let products = data.products{
                        
                        if products.count < Pagesize{
                            self.Num -= 1
                            self.CV_main.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            self.CV_main.mj_footer.endRefreshing()
                        }
                        
                        self.array_items.addObjects(from: products)
                        self.CV_main.reloadData()
                        
                        if self.array_items.count == 0{
                            self.openSearchHolder(isOpen: true)
                        }else{
                            self.openSearchHolder(isOpen: false)
                        }
                        
                    }
                    
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
    }
    
    func setupCollection() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        flowLayout.minimumLineSpacing = 10
        
        flowLayout.minimumInteritemSpacing = 10
        
        CV_main.collectionViewLayout = flowLayout
        
        CV_main.register(UINib.init(nibName: "CCell_shhuDetail", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetail")
        CV_main.register(UINib.init(nibName: "CCell_shhuDetailLine", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetailLine")
        
        CV_main.register(UINib.init(nibName: "CCellSearchHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CCellSearchHeader")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



extension shanghu_searchVC:UISearchBarDelegate{
    
    
    
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
//        searchBar.text = ""
        searchContent = searchBar.text
        getData()
 
    }
    
    
    
}

extension shanghu_searchVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("\((array_items[indexPath.row] as! ModelShopDetailItem).description)")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        Vc.shopID = shopID
        Vc.model_goods = array_items[indexPath.row] as? ModelShopDetailItem
        Vc.model_shop = self.modelShop
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
}

extension shanghu_searchVC:UICollectionViewDataSource{
    
    func SelectedHeadIndex(Index:Int){
        self.sortIndex = Index
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 44)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCellSearchHeader", for: indexPath) as! CCellSearchHeader
        headerView.delegate = self
        
        return headerView
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return sectionNum!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return array_items.count
        
//        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetail", for: indexPath) as! CCell_shhuDetail
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetailLine", for: indexPath) as! CCell_shhuDetailLine
        
        if numPreRow == 2 {
            cell.setData(Model: array_items[indexPath.row] as! ModelShopDetailItem)
        }else{
            cell1.setData(Model: array_items[indexPath.row] as! ModelShopDetailItem)
        }
        
//        return cell
        
        return numPreRow == 2 ? cell : cell1
        
    }
    
    
}

extension shanghu_searchVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
//        let ItemH1 = (Int(IBScreenWidth) - PinPaiCellPadding*(2 + 1))/2
        
        let ItemH = numPreRow == 2 ? Int(Double(ItemW)*1.1) + 52 : Int(Double(ItemW)*0.3)
        
        return CGSize.init(width: ItemW, height: ItemH)
    }
    
}

