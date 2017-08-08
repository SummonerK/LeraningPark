//
//  viewMallHolder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class viewMallHolder: UIView {

    @IBOutlet weak var bton_goShopping: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRadiusFor(toview: bton_goShopping, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
    }
    @IBAction func actionGoShopping(_ sender: Any) {
        PrintFM("")
    }

}
