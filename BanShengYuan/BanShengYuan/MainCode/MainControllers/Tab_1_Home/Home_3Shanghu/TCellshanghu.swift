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
        
        setRadiusFor(toview: label_local, radius: 2, lineWidth: 0.8, lineColor: FlatPowderBlueDark)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
