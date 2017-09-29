//
//  CCellTest.swift
//  CCardTest
//
//  Created by Luofei on 2017/9/26.
//  Copyright © 2017年 FreeMud. All rights reserved.
//

import UIKit

class CCellTest: UICollectionViewCell {

    @IBOutlet weak var viewContent:UIView!
    @IBOutlet weak var label_test:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.backgroundColor = AnyColor(alpha: 0.8)
        
//        viewContent.backgroundColor = AnyColor(alpha: 0.8)
        
        viewContent.backgroundColor = UIColor.white
        
        setshadowFor(aview: viewContent, OffSet: CGSize.init(width: 0, height: 2))
        
        setRadiusFor(toview: viewContent, radius: 6, lineWidth: 0, lineColor: .clear)
        
        // Initialization code
    }

}

//MARK:-设置阴影
func setshadowFor(aview:UIView, OffSet:CGSize){
    aview.layer.shadowColor = UIColor.init(red: 125.5/255.0, green: 125.5/255.0, blue: 110.5/255.0, alpha: 0.4).cgColor
//    aview.layer.shadowColor = UIColor.blue.cgColor
    aview.layer.shadowOpacity = 1.0
    aview.layer.shadowRadius = 2
    aview.layer.shadowOffset = OffSet
}

//MARK:-设置圆角
func setRadiusFor(toview:UIView,radius:CGFloat,lineWidth:CGFloat,lineColor:UIColor){
    
    toview.layer.cornerRadius = radius
//    toview.layer.borderColor = lineColor.cgColor
    toview.layer.borderWidth = lineWidth
    toview.layer.masksToBounds = false
    
    
}
