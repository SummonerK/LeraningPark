//
//  CCellHomeIcon.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/18.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class CCellHomeIcon: UICollectionViewCell {
    
    @IBOutlet weak var imageV_icon:UIImageView!
    @IBOutlet weak var label_title:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSubviews()
    }
    
    
    func setSubviews() -> Void {
        self.IBLCorner(byRoundingCorners: .allCorners, radii: 4)
    }

}
