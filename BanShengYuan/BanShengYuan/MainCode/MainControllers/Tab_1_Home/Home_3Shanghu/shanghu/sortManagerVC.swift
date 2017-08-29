//
//  sortManagerVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class sortManagerVC: UIViewController {
    
    var shopStoreCode:String = "" //店铺
    
    //network
    
    let shopM = shopModel()
    let modelMenuListLevelPost = ModelMenuListNextLevelByNodeidPost()
    let disposeBag = DisposeBag()
    
//    let array_meun = NSMutableArray()
    var array_meun = [ModelMenuListNextLevelItem]()
    
    @IBOutlet weak var CV_main: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
//        array_meun.addObjects(from: [["男婴(3个月-2岁)","男婴(3个月-2岁)","男婴(3个月-2岁)","男婴(3个月-2岁)","男婴(3个月-2岁)"],["大衣外套","休闲西装","连衣裙","羊毛衫"]])

        setupCollectionView()
        
        getMenuData()
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "商品分类"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCollectionView() {
        
        // 1.自定义 Item 的FlowLayout
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 4
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 4
        
        CV_main.collectionViewLayout = flowLayout
        
        
        CV_main.register(UINib.init(nibName: "CCellSortManager", bundle: nil), forCellWithReuseIdentifier: "CCellSortManager")
        
        CV_main.register(UINib.init(nibName: "sortManagerHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sortManagerHeader")
        
    }
    
    func getMenuData() {
        modelMenuListLevelPost.shopId = PARTNERID_SHOP+"_"+shopStoreCode
        modelMenuListLevelPost.deep = 2
        modelMenuListLevelPost.sortName = "pid"
        modelMenuListLevelPost.nodeId = "01"
        modelMenuListLevelPost.sortOrder = 2
        
        shopM.shopGetMenuListNextLevelByNodeid(amodel: modelMenuListLevelPost)
            .subscribe(onNext: { (Posts: ModelMenuListNextLevelByNodeidResult) in
                
                if let data = Posts.data{
                    self.array_meun.removeAll()
                    self.array_meun = self.array_meun + data
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


extension sortManagerVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("")
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "sortManagerResultVC") as! sortManagerResultVC
        
        let item = array_meun[indexPath.section]
        
        let children = item.children?[indexPath.row]
        
        let result = children?.resultModel

        Vc.noid = (result?.nid)!
        Vc.stroeId = shopStoreCode
        
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sortManagerHeader", for: indexPath) as! sortManagerHeader
        
//        if indexPath.section == 0 {
//            headerView.label_name.text = "本周新品"
////            headerView.bton_searchDelete.isHidden = false
//        }else{
//            headerView.label_name.text = "秋冬新品-女士"
////            headerView.bton_searchDelete.isHidden = true
//        }
        
        let item = array_meun[indexPath.section]
        
        let resultModel = item.resultModel
        
        headerView.label_name.text = resultModel?.name
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return array_meun.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return array_meun[section].children!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellSortManager", for: indexPath) as! CCellSortManager
        
//        let letspecItem = (array_meun[indexPath.section] as! NSArray)
//        let str:String = letspecItem[indexPath.row] as! String
//        
//        cell.label_content.text = str
        
        let item = array_meun[indexPath.section]
        
        let children = item.children?[indexPath.row]
        
        let result = children?.resultModel
        
        cell.label_content.text = result?.name
        
        return cell
        
    }
    
}

extension sortManagerVC:UICollectionViewDelegateFlowLayout{

    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        let width = (IBScreenWidth - 4)/2

        return CGSize.init(width: width, height: 50)

    }

}
