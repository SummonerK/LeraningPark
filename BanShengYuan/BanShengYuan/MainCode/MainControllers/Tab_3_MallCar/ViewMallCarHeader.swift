//
//  ViewMallCarHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol ShoppingCarHeaderDelegate {
    func setChooseValue(section:Int,sectionFlag:Bool)
}

class ViewMallCarHeader: UIView {
    
    var section : Int!

    @IBOutlet weak var bton_choose: UIButton!
    
    @IBOutlet weak var label_name: UILabel!
    
    var delegate:ShoppingCarHeaderDelegate!
    
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
        
        self.delegate.setChooseValue(section: section, sectionFlag: bton_choose.isSelected)
        
    }

}
