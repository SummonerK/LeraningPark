//
//  shangHu_DetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class shangHu_DetailVC: BaseTabHiden {
    
    var sectionNum:Int? = 1
    

    @IBOutlet weak var CV_main: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "一家商户"
        
        setupCollection()
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
        
        let storyboard = UIStoryboard.init(name: "NextPages_FromHome", bundle: nil)
        let Vc = storyboard.instantiateViewController(withIdentifier: "GoodsDetailVC") as! GoodsDetailVC
        self.navigationController?.pushViewController(Vc, animated: true)
        
        PrintFM("商户\t\(indexPath.row)")
        
//        sectionNum = 2
//        
//        CV_main.reloadData()
        
    }
}

extension shangHu_DetailVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: IBScreenWidth, height: IBScreenWidth*176/375)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCell_shhuDetailHeader", for: indexPath) as! CCell_shhuDetailHeader
        
        PrintFM("section Index \(indexPath.section)")
        
        headerView.test = "sdflajfds"
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        PrintFM("history \(sectionNum!)")
        
        return sectionNum!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 3

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetail", for: indexPath) as! CCell_shhuDetail
        
        let url = URL(string: urlStr)
        
        cell.imageV_shangpin.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
        
    }
    
    
}

extension shangHu_DetailVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numPreRow = 2
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
//        PrintFM("SW:\(IBScreenWidth),ItemW:\(ItemW)")
        return CGSize.init(width: ItemW, height: Int(Double(ItemW)*1.1)+62)
    }
    
}
