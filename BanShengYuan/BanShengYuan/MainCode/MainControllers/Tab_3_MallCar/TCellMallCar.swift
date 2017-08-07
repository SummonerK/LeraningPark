//
//  TCellMallCar.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCellMallCar: UITableViewCell {

    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_spa: UILabel!
    
    @IBOutlet weak var bton_goodsChoose: UIButton!
    
    @IBOutlet weak var imageV_picture: UIImageView!
    
    @IBOutlet weak var view_countEidt: UIView!
    
    @IBOutlet weak var label_count: UILabel!
    
    @IBOutlet weak var label_price: UILabel!
    
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
    @IBAction func actionChoose(_ sender: Any) {
        if bton_goodsChoose.isSelected{
            bton_goodsChoose.isSelected = false
        }else{
            bton_goodsChoose.isSelected = true
        }
    }
    
    @IBAction func actionPlus(_ sender: Any) {
        PrintFM("")
    }
    
    @IBAction func actionFls(_ sender: Any) {
        PrintFM("")
    }
}
