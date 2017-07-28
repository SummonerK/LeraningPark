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

class shanghu_searchVC: UIViewController {
    
    var modelShop:ModelShopItem?
    
    var shopID:String?
    var searchContent:String?
    
    var sectionNum:Int? = 1
    
    var numPreRow = 2
    
    @IBOutlet weak var CV_main: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    //network
    let VipM = shopModel()
    let modelsearchPost = ModelSearchProductPost()
    let disposeBag = DisposeBag()
    
    var array_items = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FlatGrayLight
        
        searchbar.text = searchContent
        
        if searchContent != "" {
            search(content: searchContent!)
        }

//        searchbar.becomeFirstResponder()
        
        setupCollection()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func NaviBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NaviMenu(_ sender: Any) {
        
        PrintFM("meun")
        
        numPreRow = numPreRow == 1 ? 2 : 1
        self.CV_main.reloadData()

    }
    
    func search(content:String){
        modelsearchPost.shopId = shopID
        modelsearchPost.productName = content
        
        VipM.shopSearchProducts(amodel: modelsearchPost)
            .subscribe(onNext: { (posts: ModelSearchProductResult) in
                
                if let data = posts.data,let products = data.products{
                    self.array_items.addObjects(from: products)
                    self.CV_main.reloadData()
                }
                
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
    
    func setupCollection() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        flowLayout.minimumLineSpacing = 10
        
        flowLayout.minimumInteritemSpacing = 10
        
        CV_main.collectionViewLayout = flowLayout
        
        CV_main.register(UINib.init(nibName: "CCell_shhuDetail", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetail")
        CV_main.register(UINib.init(nibName: "CCell_shhuDetailLine", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetailLine")
        
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
        
        
        if searchBar.text != "" {
            search(content: searchBar.text!)
        }
 
    }
    
    
    
}

extension shanghu_searchVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("\((array_items[indexPath.row] as! ModelShopDetailItem).description)")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        Vc.model_goods = array_items[indexPath.row] as? ModelShopDetailItem
        Vc.model_shop = self.modelShop
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}

extension shanghu_searchVC:UICollectionViewDataSource{
    
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

