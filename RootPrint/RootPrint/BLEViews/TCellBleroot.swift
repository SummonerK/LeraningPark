//
//  TCellBleroot.swift
//  BLEDemo
//
//  Created by Luofei on 2018/9/11.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class TCellBleroot: UITableViewCell {
    
    @IBOutlet weak var label_des:UILabel!
    @IBOutlet weak var label_title:UILabel!
    @IBOutlet weak var label_subtitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
