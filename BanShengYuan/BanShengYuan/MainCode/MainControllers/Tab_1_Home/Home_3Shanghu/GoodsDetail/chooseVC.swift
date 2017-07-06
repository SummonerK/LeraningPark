//
//  chooseVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/28.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

enum ChooseCoverActionType {
    case ADD  //加数量
    case Fls   //减数量
    case CLOSE //关闭
}

protocol ChooseCoverVDelegate{
    func setAction(actionType:ChooseCoverActionType)
    func buyNowAction(items:NSArray)
}

class chooseVC: UIViewController {
    
    @IBOutlet weak var viewAdd: UIView!
    
    var delegate:ChooseCoverVDelegate?
    
    var array = NSMutableArray()
    
    @IBOutlet weak var imageVsub: UIImageView!
    
    @IBOutlet weak var label_count: UILabel!
    
    @IBOutlet weak var collection_main: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageVsub.image = createImageWithColor(color: UIColor.white)
        setRadiusFor(toview: imageVsub, radius: 3, lineWidth: 0, lineColor: UIColor.white)
        
        setRadiusFor(toview: viewAdd, radius: 3, lineWidth: 0.8, lineColor: FlatBlackLight)
        
        setupCollectionView()
   
    }
    @IBAction func closeCover(_ sender: Any) {
        self.delegate?.setAction(actionType: .CLOSE)
    }
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
        self.delegate?.buyNowAction(items: array)
    }
    
    //添加数量
    @IBAction func countAdd(_ sender: Any) {
        self.delegate?.setAction(actionType: .ADD)
    }
    //减少商品数量
    @IBAction func countFls(_ sender: Any) {
        self.delegate?.setAction(actionType: .Fls)
    }
    
    func setupCollectionView() {
        
        // 1.自定义 Item 的FlowLayout
        let flowLayout = UICollectionViewFlowLayout()

        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 4, 2, 4)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 4
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 4
        
        collection_main.collectionViewLayout = flowLayout
        
        collection_main.register(UINib.init(nibName: "CCellChooseCover", bundle: nil), forCellWithReuseIdentifier: "CCellChooseCover")
        
        collection_main.register(UINib.init(nibName: "CCellChooseVCHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CCellChooseVCHeader")
        
    }

}



extension chooseVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        PrintFM("item\t\(indexPath.row)")
        
    }
    
}

extension chooseVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 44)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCellChooseVCHeader", for: indexPath) as! CCellChooseVCHeader
        
        if indexPath.section == 0{
            headerView.label_title.text = "颜色分类"
        }else{
            headerView.label_title.text = "尺码"
        }
        
        headerView.layoutIfNeeded()
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellChooseCover", for: indexPath) as! CCellChooseCover
        
        return cell
        
    }
    
}

let ChooseCoverCellPadding = 4

extension chooseVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numPreRow = 3
        let ItemW = (Int(IBScreenWidth - 20) - ChooseCoverCellPadding*(numPreRow + 1))/numPreRow
        
//        PrintFM("SW:\(IBScreenWidth),ItemW:\(ItemW)")
        return CGSize.init(width: ItemW, height: 40)
    }
    
}
