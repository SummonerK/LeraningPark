//
//  view_orderFooter.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/29.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class view_orderFooter: UIView {

    @IBOutlet weak var bton_extend: UIButton!
    
    @IBOutlet weak var bton_received: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRadiusFor(toview: bton_extend, radius: 4, lineWidth: 1, lineColor: FlatLocalMain)
        setRadiusFor(toview: bton_received, radius: 4, lineWidth: 1, lineColor: FlatLocalMain)
        
    }
    
    override func layoutSubviews() {
        setupSubviews()
    }
    
    func setupSubviews(){
        
        
    }

}
