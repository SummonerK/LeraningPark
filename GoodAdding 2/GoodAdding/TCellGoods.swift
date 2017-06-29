//
//  TCellGoods.swift
//  GoodAdding
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCellGoods: UITableViewCell {
    
    typealias buttonClickBackCall = (_ goodsImg : UIView)->Void
    var buttonClickBack : buttonClickBackCall?
    
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var bton_add: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func Adding(_ sender: Any) {
        
        if (buttonClickBack != nil) {
            buttonClickBack!(bton_add)
        }
        
    }

}
