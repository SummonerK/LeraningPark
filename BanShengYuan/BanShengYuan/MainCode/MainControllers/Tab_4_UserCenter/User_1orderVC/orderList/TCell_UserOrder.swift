//
//  TCell_UserOrder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCell_UserOrder: UITableViewCell {

    @IBOutlet weak var imagev_sub: UIImageView!
    
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_des: UILabel!
    
    @IBOutlet weak var lable_labels: UILabel!
    
    @IBOutlet weak var lable_num: UILabel!
    
    @IBOutlet weak var label_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRadiusFor(toview: imagev_sub, radius: 3, lineWidth: 0, lineColor: UIColor.clear)
        
    }
    
    func setContent(product:ModelShopDetailItem) {
        label_name.text = product.name
        lable_labels.text = product.specification
        lable_num.text = "x" + (product.productNumber?.description)!
        
        if let price = product.finalPrice {
            
            let str = String(describing: price)
            
            label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
            
        }
        
        let url = URL(string: product.picture!)
        
        imagev_sub.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
