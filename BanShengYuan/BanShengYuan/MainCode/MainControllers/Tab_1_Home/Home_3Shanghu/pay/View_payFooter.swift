//
//  View_payFooter.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/29.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class View_payFooter: UIView {

    var TotalPrice:Int = 0{
        willSet{
            
        }
        didSet{
            let str = String(describing: TotalPrice)
            label_total.text = String.init("¥ \(String(describing: str.fixPrice()))")
        }
    }
    
    var transPrice:Int = 0{
        willSet{
            
        }
        didSet{
            let str = String(describing: transPrice)
            label_yun.text = String.init("¥ \(String(describing: str.fixPrice()))")
        }
    }
    
    @IBOutlet weak var label_yun: UILabel!
    
    @IBOutlet weak var label_total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        setupSubviews()
    }
    
    func setupSubviews(){
        
        
    }

}
