//
//  chooseVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/28.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

enum ChooseCoverActionType {
    case ADD  //加数量
    case Fls   //减数量
    case CLOSE //关闭
}

protocol ChooseCoverVDelegate{
    func setAction(actionType:ChooseCoverActionType)
    func buyNowAction(items:NSMutableDictionary)
}

class chooseVC: UIViewController {
    
    //network
    
    let VipM = shopModel()
    let modelMenupost = ModelShopDetailMenuPost()
    
    let disposeBag = DisposeBag()
    //规格
    let array_meun = NSMutableArray()
    var dic_menuchoose = NSMutableDictionary()
    
    @IBOutlet weak var viewAdd: UIView!
    
    var delegate:ChooseCoverVDelegate?
    

    @IBOutlet weak var imageVsub: UIImageView!
    
    @IBOutlet weak var label_count: UILabel!
    
    @IBOutlet weak var label_price: UILabel!
    
    @IBOutlet weak var label_kc: UILabel!
    
    @IBOutlet weak var collection_main: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageVsub.image = createImageWithColor(color: UIColor.white)
        
        setshadowFor(aview: imageVsub, OffSet: CGSize.init(width: 4, height: 4))
        
        setRadiusFor(toview: imageVsub, radius: 4, lineWidth: 0, lineColor: FlatWhiteLight)
        
        setRadiusFor(toview: viewAdd, radius: 3, lineWidth: 0.6, lineColor: FlatGrayDark)
        
        setupCollectionView()
   
    }
    
    
    //    获取商户meun 规格
    
    func getMeun(productid:String) {
        
        modelMenupost.productId = productid
        
        VipM.shopGetDetailMenus(amodel: modelMenupost)
            .subscribe(onNext: { (posts: ModelShopDetailDetaiMenuItem) in
                
                if let data = posts.data,let products = data.products{
                    for item in products{
                        
                        if let spec = item.specificationList{
                            
                            self.array_meun.removeAllObjects()
                            
                            self.array_meun.addObjects(from: spec)
                            
                            PrintFM("meun data \(self.array_meun)")
                            
                            for item in self.array_meun{
                                
                                if let partstr = (item as! ModelMenuSpecItem).partName{
                                    
                                    self.dic_menuchoose.setValue("", forKey: partstr)
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        
                        if let prospec = item.productSpecification{
                            PrintFM("prospec = \(prospec)")
                        }
                        
                        
                    }
                    
//                    解析规格数据
                    
                    self.collection_main.reloadData()
                    
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
    
    

    @IBAction func closeCover(_ sender: Any) {
        self.delegate?.setAction(actionType: .CLOSE)
    }
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
        self.delegate?.buyNowAction(items: self.dic_menuchoose)
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
        
        let letspecItem = (array_meun[indexPath.section] as! ModelMenuSpecItem)
        
        if let arrayitem = letspecItem.value{
            
            let value = arrayitem[indexPath.row]
            
            if let key = letspecItem.partName {
                
                self.dic_menuchoose.setValue(value, forKey: key)
                
                PrintFM("dic_menuchoose\(dic_menuchoose)")
                
                self.collection_main.reloadData()
                
            }
            
        }
        
    }
    
}

extension chooseVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: IBScreenWidth, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CCellChooseVCHeader", for: indexPath) as! CCellChooseVCHeader
        
        let letspecItem = (array_meun[indexPath.section] as! ModelMenuSpecItem)
        
        if letspecItem.partName == "color" {
            headerView.label_title.text = "颜色"
        }
        
        if letspecItem.partName == "size" {
            headerView.label_title.text = "尺寸"
        }
        
        headerView.layoutIfNeeded()
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return array_meun.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if let arrayitem = (array_meun[section] as! ModelMenuSpecItem).value{
            return arrayitem.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellChooseCover", for: indexPath) as! CCellChooseCover
        
        let letspecItem = (array_meun[indexPath.section] as! ModelMenuSpecItem)
        
        if let arrayitem = letspecItem.value{
            cell.label_item.text = arrayitem[indexPath.row]
            
            if let key = letspecItem.partName {
                
                let chosevalue = (self.dic_menuchoose.value(forKey: key) as! String)
                
                if arrayitem[indexPath.row] == chosevalue{
                    cell.imageV_back.isHidden = false
                }else{
                    cell.imageV_back.isHidden = true
                }
                
            }
            
        }
        
        return cell
        
    }
    
}

let ChooseCoverCellPadding = 4

extension chooseVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numPreRow = 4
        let ItemW = (Int(IBScreenWidth - 20) - ChooseCoverCellPadding*(numPreRow + 1))/numPreRow
        
        return CGSize.init(width: ItemW, height: 36)
    }
    
}
