//
//  CCell_pinPai.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class CCell_pinPai: UICollectionViewCell {

    @IBOutlet weak var imageV_shopIcon: UIImageView!
    
    @IBOutlet weak var label_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
        
    }
    
    func setupView() {
        
//        self.contentView.backgroundColor = UIColor.white
        
//        let numPreRow = 2
//        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        setRadiusFor(toview: imageV_shopIcon, radius: 50, lineWidth: 0, lineColor: UIColor.clear)
        
    }

}
