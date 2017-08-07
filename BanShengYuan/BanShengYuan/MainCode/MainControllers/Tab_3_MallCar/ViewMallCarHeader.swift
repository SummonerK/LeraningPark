//
//  ViewMallCarHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ViewMallCarHeader: UIView {

    @IBOutlet weak var bton_choose: UIButton!
    
    @IBOutlet weak var label_name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bton_choose.setImage(UIImage.init(named: "choose_s"), for: .selected)
        
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        PrintFM("")
    }
    @IBAction func actionChoose(_ sender: Any) {
        
        if bton_choose.isSelected{
            bton_choose.isSelected = false
        }else{
            bton_choose.isSelected = true
        }
        
    }

}
