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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
        
    }
    
    func setupView() {
        
//        self.contentView.backgroundColor = UIColor.white
        
        let numPreRow = 2
        let ItemW = (Int(IBScreenWidth) - PinPaiCellPadding*(numPreRow + 1))/numPreRow
        
        imageV_shopIcon.layer.cornerRadius = CGFloat(ItemW)*0.75*0.5
        imageV_shopIcon.layer.borderColor = UIColor.init(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 0.7).cgColor
        imageV_shopIcon.layer.masksToBounds = true
        imageV_shopIcon.layer.borderWidth = 2
        
    }

}
