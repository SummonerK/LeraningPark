//
//  home_pinPaiVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

let PinPaiCellPadding = 10

class home_pinPaiVC: BaseTabHiden {
    @IBOutlet weak var CollectionV_main: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "品牌"

        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        
        // 1.自定义 Item 的FlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        
// 2.设置 Item 的 Size
        
//        let itemW = Int(IBScreenWidth/2) - 10
//        
//        
//        flowLayout.itemSize = CGSize.init(width: itemW, height: itemW)
        
        // 3.设置 Item 的排列方式
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 10
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 10
        
// 7.设置UICollectionView 的页头尺寸
//        flowLayout.headerReferenceSize = CGSizeMake(100, 50)
        
// 8.设置 UICollectionView 的页尾尺寸
//        flowLayout.footerReferenceSize = CGSizeMake(100, 50)
        
        CollectionV_main.collectionViewLayout = flowLayout
        
        CollectionV_main.register(UINib.init(nibName: "CCell_pinPai", bundle: nil), forCellWithReuseIdentifier: "CCell_pinPai")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}



extension home_pinPaiVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("商户\t\(indexPath.row)")
        
    }
    
}

extension home_pinPaiVC:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_pinPai", for: indexPath) as! CCell_pinPai
        
        let url = URL(string: urlStr)
        
        cell.imageV_shopIcon.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
        
    }
    
}

extension home_pinPaiVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numPreRow = 2
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        PrintFM("SW:\(IBScreenWidth),ItemW:\(ItemW)")
        return CGSize.init(width: ItemW, height: ItemW)
    }
    
}
