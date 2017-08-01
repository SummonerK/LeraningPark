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
    func buyNowAction(items:NSMutableDictionary,count:Int)
}

class chooseVC: UIViewController {
    
    //network
    
    let VipM = shopModel()
    let modelMenupost = ModelShopDetailMenuPost()
    
    let disposeBag = DisposeBag()
    //规格
    let array_meun = NSMutableArray()
    var dic_menuchoose = NSMutableDictionary()
//    var array_keys = NSMutableArray()
    let array_prospec = NSMutableArray()
    
    //数量
    var proCount:Int = 1
    var productid:Int = 0
    
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
        
        label_count.text = proCount.description
        
        setshadowFor(aview: imageVsub, OffSet: CGSize.init(width: 4, height: 4))
        
        setRadiusFor(toview: imageVsub, radius: 4, lineWidth: 0, lineColor: FlatWhiteLight)
        
        setRadiusFor(toview: viewAdd, radius: 3, lineWidth: 0.6, lineColor: FlatGrayDark)
        
        setupCollectionView()
   
    }
    
//    获取商户meun 规格
    
    func getMeun(productid:String) {
        
        modelMenupost.productId = productid
        
        self.productid = productid.intValue!
        
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
                                
//                                self.array_keys.addObjects(from: self.dic_menuchoose.allKeys)
                                
                            }
                            
                        }
                        
                        
                        
                        if let prospec = item.productSpecification{
                            
                            self.array_prospec.removeAllObjects()
                            
                            self.array_prospec.addObjects(from: prospec)
                            
                            PrintFM("prospec = \(self.array_prospec)")
                            
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
    
//    MARK:支付
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
        self.delegate?.buyNowAction(items: self.dic_menuchoose,count: proCount)
    }
    
//    MARK:编辑商品数量
    
    //添加数量
    @IBAction func countAdd(_ sender: Any) {
        self.delegate?.setAction(actionType: .ADD)
        
        if proCount < 1 {
            proCount += 1
        }else{
            HUDShowMsgQuick(msg: "库存不足", toView: KeyWindow, time: 0.8)
        }
        
        label_count.text = proCount.description
        
    }
    
    //减少商品数量
    @IBAction func countFls(_ sender: Any) {
        self.delegate?.setAction(actionType: .Fls)
        
        if proCount > 1 {
            proCount -= 1
        }else{
            HUDShowMsgQuick(msg: "至少添加一个商品", toView: KeyWindow, time: 0.8)
        }
        
        
        label_count.text = proCount.description
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
    
    //筛选符合规格商品
    
    func checkValue(toKeyPart:String){
        
//        array_meun.removeAllObjects()
//        选中属性值
        let toValue = self.dic_menuchoose.value(forKey: toKeyPart) as! String

        for i in 0...array_meun.count-1{
            
            let item = array_meun[i] as! ModelMenuSpecItem
            
            PrintFM("item\(String(describing: item.toJSONString()))")
            
            if let partName = item.partName{
                
                //非选中的part 都要遍历筛选
                if toKeyPart == partName {
                    
                }else{
                    
                    let array_temp = NSMutableArray()
                    
                    for m in 0...array_prospec.count-1{
                        
                        let dic_temp = array_prospec[m] as! NSDictionary
//                        prospec 中 item属性与选中属性相同的 则: partName下属性->整理集合
                        if toValue == dic_temp[toKeyPart] as! String{
                            
                            let partValue = dic_temp[partName] as! String
                            
                            array_temp.add(partValue)
                            
                        }
                    }
                    
//                    已经筛选的属性集合，赋值给当前的 MENU item
                    item.value = array_temp as? [String]
                    
                    let selectedPartValue = self.dic_menuchoose.value(forKey: partName) as! String
                    
                    PrintFM("another value = \(selectedPartValue)\n array = \(array_temp)")
                    
                    if selectedPartValue != "" && array_temp.count > 0{
                        for j in 0...array_temp.count-1{
                            if (array_temp[j] as! String) == selectedPartValue{
                                self.dic_menuchoose.setValue(selectedPartValue, forKey: partName)
                                break
                            }else{
                                self.dic_menuchoose.setValue("", forKey: partName)
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
        getGoodsChoosed()
        
    }
    
    //筛选符合规格商品goodsID
    
    func getChoosedGoodsID() -> Int {
        
        let array = self.dic_menuchoose.allKeys as! [String]
        
        if array_prospec.count > 0 {
            
        }else{
            return self.productid
        }
        
        for i in 0...array_prospec.count-1{
            
            let dic = array_prospec[i] as! NSDictionary
            
            for item in 0...array.count-1{
                
                let key = array[item]
                
                if (self.dic_menuchoose[key] as! String) == (dic[key] as! String){
                    if item == array.count-1 {
                        
                        return (dic["productId"] as! Int)
                    }else{
                        continue
                    }
                }
                
            }
 
        }
        
        return 0
        
    }
    
    func getGoodsChoosed() {
    
        if getChoosedGoodsID() != 0{
            modelMenupost.productId = "\(getChoosedGoodsID())"
            
            VipM.shopGetDetailMenus(amodel: modelMenupost)
                .subscribe(onNext: { (posts: ModelShopDetailDetaiMenuItem) in
                    
                    if let data = posts.data,let products = data.products{
                        for item in products{
                            
                            if let picture = item.picture{
                                
                                let url = URL(string: picture)
                                
                                self.imageVsub.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in
                                    
                                })
                                
                            }
                            
                            if let price = item.finalPrice{
                                
                                let str = String(describing: price)
                                
                                self.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
                            }
                            
                            
                        }
                        
                    }
                    
                },onError:{error in
                    
                })
                .addDisposableTo(disposeBag)
            
        }
        
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
                
                self.checkValue(toKeyPart: key)
                
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
        
        headerView.label_title.text = letspecItem.partName?.trueItemValue
        
//        if letspecItem.partName == "color" {
//            headerView.label_title.text = "颜色"
//        }
//        
//        if letspecItem.partName == "zipper" {
//            headerView.label_title.text = "拉链"
//        }
//        
//        if letspecItem.partName == "size" {
//            headerView.label_title.text = "尺寸"
//        }
        
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
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    
}

let ChooseCoverCellPadding = 4

extension chooseVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
//        let numPreRow = 4
//        let ItemW = (Int(IBScreenWidth - 20) - ChooseCoverCellPadding*(numPreRow + 1))/numPreRow
//        
//        return CGSize.init(width: ItemW, height: 36)
        
//        return CGSize.init(width: (indexPath.item * 10) + 20, height: 36)
        
        let letspecItem = (array_meun[indexPath.section] as! ModelMenuSpecItem)
        
        if let arrayitem = letspecItem.value{
            let str:String = arrayitem[indexPath.row]
            return CGSize.init(width: str.getLabSize(font: FontLabelPFLight(size: 12)).width + 28, height: 36)
        }else{
            return CGSize.zero
        }
        
    }
    
}
