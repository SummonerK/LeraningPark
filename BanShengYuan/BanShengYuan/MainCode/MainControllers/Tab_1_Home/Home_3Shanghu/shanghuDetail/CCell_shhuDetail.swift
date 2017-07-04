//
//  CCell_shhuDetail.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class CCell_shhuDetail: UICollectionViewCell {

    @IBOutlet weak var imageV_shangpin: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_pirce: UILabel!
    @IBOutlet weak var label_sales: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(Model:ModelShopDetailItem){
        
//        PrintFM(Model.description)
        
        let url = URL(string: Model.picture!)
        
        imageV_shangpin.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
        
        label_title.text = Model.name
        label_pirce.text = Model.originalPrice
        label_sales.text = Model.saleCount
    }

}
