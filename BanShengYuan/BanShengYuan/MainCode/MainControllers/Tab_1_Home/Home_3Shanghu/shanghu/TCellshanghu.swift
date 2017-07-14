//
//  TCellshanghu.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/15.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCellshanghu: UITableViewCell {
    @IBOutlet weak var imageV_shanghuIcon: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_info: UILabel!

    @IBOutlet weak var label_local: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setRadiusFor(toview: label_local, radius: 2, lineWidth: 0.8, lineColor: FlatLocalMain)
    }
    
    func setData(Model:ModelShopItem){
 
        label_name.text = Model.storeName
//        label_info.text = Model.fullName
        
        for pagemodel in Model.businessImages!{
            if  let imageurl = pagemodel.imageUrl {
                
                let url = URL(string: imageurl)
                
                imageV_shanghuIcon.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
                
                break
            }
        }
        
        
        if let shipid = Model.storeCode,shipid == "107"{
            label_local.text = "LMS1-107"
        }else{
            label_local.text = "大创A-101"
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
