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

class shangHu_DetailVC: UIViewController {
    
    @IBOutlet weak var CV_main: UICollectionView!
    
    //network
    
    let VipM = shopModel()
    let modelshopDetailPost = ModelShopDetailPost()
    let disposeBag = DisposeBag()
    
    //data
    var array_items = NSMutableArray()

    
    var sectionNum:Int? = 1
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        getData()
        
    }
    @IBAction func NaviBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NaviMenu(_ sender: Any) {
        
        PrintFM("meun")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
/*

     
http://118.89.192.122:9998/Query/Shop/GetAllProducts?pagesize=10&pagenumber=1&shopId=178a14ba-85a8-40c7-9ff4-6418418f5a0c_31310040&nsukey=Bvc49gQ+pn6PeND1mZWngaBRxMWiqclFWKzklffE8t6KVEOaCV997IFnPHhKJV3Tz+9/j8ZNHjSgSqJbGkVdLXDMLyFcAw4Bt4UqUuDjkOgM1vm58hHhVm0ZpXBR0wNKidHNkhDCUD194P5RndaQ4n5ztVxlwc0GTO3Q6bUls+lSXuCOV+UVjh5Q4uSV+Yox
     
 */
    
    func getData() {
        modelshopDetailPost.shopId = shipid
        modelshopDetailPost.pagesize = 10
        modelshopDetailPost.pagenumber = 1
//        modelshopDetailPost.nsukey = nsukey
        
        VipM.shopGetAllProducts(amodel: modelshopDetailPost)
            .subscribe(onNext: { (posts: [ModelShopDetailItem]) in
//                PrintFM("shopDetailItem\(posts)")
                
                self.array_items = posts as! NSMutableArray
                
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

extension shangHu_DetailVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("\((array_items[indexPath.row] as! ModelShopDetailItem).description)")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        Vc.model_goods = array_items[indexPath.row] as! ModelShopDetailItem
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}

extension shangHu_DetailVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 110 + IBScreenWidth*180/375)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCell_shhuDetailHeader", for: indexPath) as! CCell_shhuDetailHeader
        
        headerView.imageV_icon.image = BundlePngWithName("ppdaiso")
        
        headerView.imageV_light.image = BundleImageWithName("subactivity2")
        
        headerView.layoutIfNeeded()
        
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
        
//        cell.imageV_shangpin.image = createImageWithColor(color: FlatWhiteLight)
        
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
