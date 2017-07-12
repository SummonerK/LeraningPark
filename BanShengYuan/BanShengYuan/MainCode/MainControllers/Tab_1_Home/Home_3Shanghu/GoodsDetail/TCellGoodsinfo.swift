//
//  TCellGoodsinfo.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol TCellGoodsinfoDelegate{
    func setAction(actionType:String)
}

class TCellGoodsinfo: UITableViewCell {
    
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_price: UILabel!
    
    var delegate:TCellGoodsinfoDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func chooseItems(_ sender: Any) {
        self.delegate?.setAction(actionType: "00")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
