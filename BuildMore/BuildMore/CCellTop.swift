//
//  CCellTop.swift
//  BuildMore
//
//  Created by Luofei on 2017/7/25.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

//MARK:-设置圆角
func setRadiusFor(toview:UIView,radius:CGFloat,lineWidth:CGFloat,lineColor:UIColor){
    toview.layer.cornerRadius = radius
    toview.layer.borderColor = lineColor.cgColor
    toview.layer.borderWidth = lineWidth
    toview.layer.masksToBounds = true
}


class CCellTop: UICollectionViewCell {

    @IBOutlet weak var label_txt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setRadiusFor(toview: self, radius: 4, lineWidth: 0, lineColor: UIColor.clear)
        
        // Initialization code
    }

}
