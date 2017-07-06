//
//  CCellChooseCover.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/4.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class CCellChooseCover: UICollectionViewCell {

    @IBOutlet weak var imageV_back: UIImageView!
    
    @IBOutlet weak var label_item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRadiusFor(toview: imageV_back, radius: 3, lineWidth: 1, lineColor: FlatGrayLight)
        
        // Initialization code
    }

}
