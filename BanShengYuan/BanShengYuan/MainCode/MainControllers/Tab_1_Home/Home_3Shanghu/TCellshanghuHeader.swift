//
//  TCellshanghuHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/15.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TCellshanghuHeader: UITableViewCell {
    
    @IBOutlet weak var IBScrollView: INOScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        IBScrollView.frame.width = IBScreenWidth
//        IBScrollView.frame.height = IBScreenWidth*176/375
        
        IBScrollView.imageArray = [
            "http://wx3.sinaimg.cn/mw690/62eeaba5ly1fee5yt59wrj20fa08lafr.jpg",
            "http://wx4.sinaimg.cn/mw690/6a624f11ly1fed4bwlbb0j20go0h6q5h.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            "http://wx2.sinaimg.cn/mw690/af0d43ddgy1fdjzefvub1j20dw09q48s.jpg"
        ]
        
//        IBScrollView.titleArray = [
//            "111111",
//            "222222",
//            "333333",
//            "444444",
//        ]
        
        
        IBScrollView.scrollDirection = .horizontal
        IBScrollView.autoScrollTimerInterval = 3.0
        IBScrollView.INOScrollViewContentMode = .scaleAspectFill
//        IBScrollView.showTextLabel = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
