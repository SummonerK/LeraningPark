//
//  TCellMallCar.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol TCellMallCarDelegate {
    func setAction(indexpath:IndexPath,actionType:ChooseCoverActionType)
    func setChooseValue(indexpath:IndexPath,cellFlag:Bool)
}

class TCellMallCar: UITableViewCell {

    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_spa: UILabel!
    
    @IBOutlet weak var bton_goodsChoose: UIButton!
    
    @IBOutlet weak var imageV_picture: UIImageView!
    
    @IBOutlet weak var view_countEidt: UIView!
    
    @IBOutlet weak var label_count: UILabel!
    
    @IBOutlet weak var label_price: UILabel!
    
    var indexpath : IndexPath!
    
    var delegate:TCellMallCarDelegate!
    
    //商品数量
    var proCount:Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bton_goodsChoose.setImage(UIImage.init(named: "choose_s"), for: .selected)
        
        setRadiusFor(toview: imageV_picture, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        setRadiusFor(toview: view_countEidt, radius: 2, lineWidth: 0.6, lineColor: FlatGrayLight)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(product:ModelShopDetailItem) {
        label_name.text = product.name
        label_spa.text = product.specification
        label_count.text = product.productNumber?.description
        proCount = product.productNumber!
        
        if let price = product.finalPrice {
            
            let str = String(describing: price)
            
            label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
            
        }
        
        let url = URL(string: product.picture!)
        
        imageV_picture.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
        
        if let flagchoose = product.chooseFlag {
            bton_goodsChoose.isSelected = flagchoose
        }
        
    }
    
    @IBAction func actionChoose(_ sender: Any) {
        if bton_goodsChoose.isSelected{
            bton_goodsChoose.isSelected = false
        }else{
            bton_goodsChoose.isSelected = true
        }
        
        self.delegate.setChooseValue(indexpath: indexpath, cellFlag: bton_goodsChoose.isSelected)
    }
    
//    MARK:编辑商品数量

//添加数量
    @IBAction func actionPlus(_ sender: Any) {
        
        self.delegate?.setAction(indexpath: indexpath, actionType: .ADD)
        
        proCount += 1
        
//        if proCount < proStock {
//            proCount += 1
//        }else{
//            HUDShowMsgQuick(msg: "库存不足", toView: KeyWindow, time: 0.8)
//        }
        
        label_count.text = proCount.description
    }
    
//减少商品数量
    @IBAction func actionFls(_ sender: Any) {
        
        if proCount > 1 {
            
            proCount -= 1
            
            self.delegate?.setAction(indexpath: indexpath, actionType: .Fls)
        }else{
            HUDShowMsgQuick(msg: "至少添加一个商品", toView: KeyWindow, time: 0.8)
        }
        
        label_count.text = proCount.description
        
    }
    
    
}
