//
//  searchSHHolderVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol SearchSHHolderDelegate {
    func SearchContent(content:String)
}

class searchSHHolderVC: UIViewController {

    @IBOutlet weak var CV_main: UICollectionView!
    
    var delegate:SearchSHHolderDelegate?
    
    let array_meun = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        array_meun.addObjects(from: [["小梅子店铺","指甲油 幻彩店铺","木棉若若店","黑白界","老张哥店铺"],["夏天的牛仔","杨柳飘飘森女","数码世界"]])
        
        setupCollectionView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView() {
        
        // 1.自定义 Item 的FlowLayout
//        let flowLayout = UICollectionViewFlowLayout()
        
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let flowLayout = UICollectionViewLeftAlignedLayout.init()
        
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 10, 2, 10)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 10
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 10
        
        CV_main.collectionViewLayout = flowLayout
        
        
        CV_main.register(UINib.init(nibName: "CCellSearchHolder", bundle: nil), forCellWithReuseIdentifier: "CCellSearchHolder")
        
        CV_main.register(UINib.init(nibName: "searchSHHolderHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "searchSHHolderHeader")
        
    }
    

}

extension searchSHHolderVC: MYCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, collectionViewHeight height: CGFloat) {
        //do something
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回每个item的size
        let letspecItem = (array_meun[indexPath.section] as! NSArray)
        let str:String = letspecItem[indexPath.row] as! String
        
        return CGSize.init(width: str.getLabSize(font: FontLabelPFLight(size: 14)).width + CGFloat(SearchSHHolderCellPadding*2), height: 30)
        
    }
}


extension searchSHHolderVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let letspecItem = (array_meun[indexPath.section] as! NSArray)
        let str:String = letspecItem[indexPath.row] as! String
        
        self.delegate?.SearchContent(content: str)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 44)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchSHHolderHeader", for: indexPath) as! searchSHHolderHeader
        
        if indexPath.section == 0 {
            headerView.label_name.text = "最近搜索"
            headerView.bton_searchDelete.isHidden = false
        }else{
            headerView.label_name.text = "热门搜索"
            headerView.bton_searchDelete.isHidden = true
        }
        
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return array_meun.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return (array_meun[section] as! NSArray).count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellSearchHolder", for: indexPath) as! CCellSearchHolder
        
        let letspecItem = (array_meun[indexPath.section] as! NSArray)
        let str:String = letspecItem[indexPath.row] as! String
        
        cell.label_content.text = str
        
        return cell
        
    }
    
}

let SearchSHHolderCellPadding = 13
//extension searchSHHolderVC:UICollectionViewDelegateFlowLayout{
//    
//    //返回cell 上下左右的间距
//    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        
//        let letspecItem = (array_meun[indexPath.section] as! NSArray)
//        let str:String = letspecItem[indexPath.row] as! String
//        
//        return CGSize.init(width: str.getLabSize(font: FontLabelPFLight(size: 14)).width + CGFloat(SearchSHHolderCellPadding*2), height: 30)
//        
//    }
//    
//}
