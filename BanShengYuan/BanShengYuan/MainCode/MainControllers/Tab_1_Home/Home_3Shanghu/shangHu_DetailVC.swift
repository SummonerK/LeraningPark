//
//  shangHu_DetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class shangHu_DetailVC: BaseTabHiden {

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
        CV_main.register(UINib.init(nibName: "CCell_shhuDetailHeader", bundle: nil), forCellWithReuseIdentifier: "CCell_shhuDetailHeader")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

extension shangHu_DetailVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("商户\t\(indexPath.row)")
        
    }
    
}

extension shangHu_DetailVC:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        default:
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetailHeader", for: indexPath) as! CCell_shhuDetailHeader
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell_shhuDetail", for: indexPath) as! CCell_shhuDetail
        
        let url = URL(string: urlStr)
        
        cell.imageV_shangpin.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        return cell
        
    }
    
}

extension shangHu_DetailVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.section == 0{
            return CGSize.init(width: Int(IBScreenWidth - 20), height: Int((IBScreenWidth - 20)*0.6))
        }
        
        let numPreRow = 2
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        PrintFM("SW:\(IBScreenWidth),ItemW:\(ItemW)")
        return CGSize.init(width: ItemW, height: Int(Double(ItemW)*1.1)+62)
    }
    
}
