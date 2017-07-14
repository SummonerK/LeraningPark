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
    @IBOutlet weak var view_info: UIView!

    @IBOutlet weak var label_local: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setRadiusFor(toview: view_info, radius: 2, lineWidth: 0.6, lineColor: FlatLocalMain)
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
            label_info.text = "LMS集合线下实体、O2O、品牌商业运营团队、潮流造势团队，将独立设计师品牌等潮流元素打造出潮流品牌。"
            
        }else{
            label_local.text = "大创A-101"
            label_info.text = "合肥大创生活馆是日本大创在安徽的首家门店，大创为您提供从厨房用品、洗漱用品等一系列生活用品。"
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
