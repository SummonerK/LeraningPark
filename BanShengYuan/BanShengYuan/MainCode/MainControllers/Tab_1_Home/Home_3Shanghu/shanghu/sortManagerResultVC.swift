//
//  sortManagerResultVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/29.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class sortManagerResultVC: UIViewController,shhuDetailHeaderDelegate {
    
    var noid:String?
    var stroeId:String?
    //network
    
    let shopM = shopModel()
    let modelMenuListLevelPost = ModelMenuListNextLevelByNodeidPost()
    let disposeBag = DisposeBag()
    
    var array_product = [ModelShopDetailItem]()
    
    @IBOutlet weak var CV_main: UICollectionView!
    var sectionNum:Int? = 1
    var numPreRow = 2
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var array_sort = [("saleCount",1),("finalPrice",1),("pid",1)]
    var sortIndex = 0{
        willSet{
            
        }
        didSet{
            
            if oldValue == sortIndex {
                PrintFM("sortIndex = \(sortIndex)")
//                getIndexData()
            }else{
//                getData()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        getData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    
    @IBAction func NaviBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func NaviMenu(_ sender: Any) {
        
        PrintFM("meun")
        
        numPreRow = numPreRow == 1 ? 2 : 1
        self.CV_main.reloadData()
        
    }
    
    func getIndexData() {
    
        modelMenuListLevelPost.shopId = PARTNERID_SHOP+"_"+stroeId!
        modelMenuListLevelPost.deep = 2
        modelMenuListLevelPost.sortName = "pid"
        modelMenuListLevelPost.nodeId = noid
        modelMenuListLevelPost.sortOrder = 2
        
        shopM.shopGetMenuProductsByLevelNodeid(amodel: modelMenuListLevelPost)
            .subscribe(onNext: { (Posts: ModelMenuProductsByLevelNodeidResult) in
                
                if let data = Posts.data{
                    
                    self.array_product.removeAll()
                    
                    
                    for product in data{
                        
                        self.array_product.append(product.resultModel!)
                        
                        self.CV_main.reloadData()
                    }
                    
                    self.CV_main.reloadData()
                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func getData() {
        
        modelMenuListLevelPost.shopId = PARTNERID_SHOP+"_"+stroeId!
        modelMenuListLevelPost.deep = 2
        modelMenuListLevelPost.sortName = "pid"
        modelMenuListLevelPost.nodeId = noid
        modelMenuListLevelPost.sortOrder = 2
        
        shopM.shopGetMenuProductsByLevelNodeid(amodel: modelMenuListLevelPost)
            .subscribe(onNext: { (Posts: ModelMenuProductsByLevelNodeidResult) in
                
                if let data = Posts.data{
                    
                    self.array_product.removeAll()
                    
                    
                    for product in data{
                        
                        self.array_product.append(product.resultModel!)
                        
                        self.CV_main.reloadData()
                    }
                    
                    self.CV_main.reloadData()
                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension sortManagerResultVC:UISearchBarDelegate{
    
    
    
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
        
    }
    
    
    
}

extension sortManagerResultVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("\(indexPath.row)")
    }
    
}

extension sortManagerResultVC:UICollectionViewDataSource{
    
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
        
        return array_product.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetail", for: indexPath) as! CCell_shhuDetail
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetailLine", for: indexPath) as! CCell_shhuDetailLine
        
        if numPreRow == 2 {
            cell.setData(Model: array_product[indexPath.row])
        }else{
            cell1.setData(Model: array_product[indexPath.row])
        }
        
        return numPreRow == 2 ? cell : cell1
        
    }
    
    
}

extension sortManagerResultVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        //        let ItemH1 = (Int(IBScreenWidth) - PinPaiCellPadding*(2 + 1))/2
        
        let ItemH = numPreRow == 2 ? Int(Double(ItemW)*1.1) + 52 : Int(Double(ItemW)*0.3)
        
        return CGSize.init(width: ItemW, height: ItemH)
    }
    
}
