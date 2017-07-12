//
//  view_goodsMore.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol view_goodsMoreDelegate{
    func goodsMoreOpen()
}

class view_goodsMore: UIView {
    
    @IBOutlet weak var bton_goodsmore: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var delegate:view_goodsMoreDelegate?

    @IBAction func goodsDetailAction(_ sender: Any) {
        
        bton_goodsmore.isEnabled = false
        
        self.delegate?.goodsMoreOpen()
    }

}
