//
//  TCellPayAddress.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCellPayAddress: UITableViewCell {

    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_phone: UILabel!
    
    @IBOutlet weak var label_address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
