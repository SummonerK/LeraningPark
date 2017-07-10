//
//  view_shanghuHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class view_shanghuHeader: UIView {
    
    var isscroll:Bool?

    /// 返回每一页需显示的内容图
    public typealias ContentImages = (Void) -> Array<String>
    open var contentImages : ContentImages?
    
    fileprivate lazy var imageArray : Array<String> = {
        
        return self.contentImages?() ?? ["PIC"]
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        let header = INOScrollView(frame: self.frame)
        self.addSubview(header)
        header.imageArray = imageArray
        header.scrollDirection = .horizontal
        header.autoScrollTimerInterval = 3.0
        header.INOScrollViewContentMode = .scaleAspectFill
        header.autoScroll = isscroll!
        
//        header.showTextLabel = true

    }
    
    override func layoutSubviews() {
        setupSubviews()
    }

}
