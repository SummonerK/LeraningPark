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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
