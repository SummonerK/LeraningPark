//
//  CCell_shhuDetailLine.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/20.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class CCell_shhuDetailLine: UICollectionViewCell {

    @IBOutlet weak var imageV_shangpin: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_pirce: UILabel!
    @IBOutlet weak var label_sales: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRadiusFor(toview: self, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        //        setRadiusFor(toview: imageV_shangpin, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        // Initialization code
    }
    
    func setData(Model:ModelShopDetailItem){
        
        //        PrintFM(Model.description)
        
        let url = URL(string: Model.picture!)
        
        imageV_shangpin.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
        
        label_title.text = "\(String(describing: Model.name!))"
        
        //         \(String(describing: Model.specification!))
        
        if let price = Model.originalPrice {
            
            let str = String(describing: price)
            
            label_pirce.text = String.init("¥ \(String(describing: str.fixPrice()))")
            
        }
        
        label_sales.text = String(describing: Model.saleCount!).fixNumString()
        
        //        label_sales.text = "12000".fixNumString()
        
    }
    
}
