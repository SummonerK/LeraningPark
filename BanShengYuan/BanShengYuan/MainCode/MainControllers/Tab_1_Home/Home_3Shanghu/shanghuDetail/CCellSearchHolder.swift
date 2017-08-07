//
//  CCellSearchHolder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class CCellSearchHolder: UICollectionViewCell {
    
    @IBOutlet weak var label_content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContentView()
        
        // Initialization code
    }
    
    func setContentView() {
        setRadiusFor(toview: self, radius: 3, lineWidth: 0, lineColor: UIColor.clear)
    }

}
