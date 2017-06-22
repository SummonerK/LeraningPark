//
//  view_userHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import Kingfisher

typealias UserContent = (Void) -> Dictionary<String, Any>

class view_userHeader: UIView {

    @IBOutlet weak var imageV_Header: UIImageView!
    
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_phone: UILabel!
    
    open var usercontent : UserContent?
    
    fileprivate lazy var dic_data : Dictionary<String,Any> = {
        return self.usercontent?() ?? ["name":"","url":"","phone":""]
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRadiusFor(toview: imageV_Header, radius: IBScreenWidth*176/375*0.4/2, lineWidth: 1.6, lineColor: UIColor.white)
        setshadowFor(aview: imageV_Header, OffSet: CGSize.init(width: -1, height: -1))
        
    }
    
    override func layoutSubviews() {
        setupSubviews()
    }
    
    func setupSubviews(){
        
        let url = URL(string: dic_data["url"] as! String)
        
        imageV_Header.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        label_name.text = dic_data["name"] as? String
        label_phone.text = dic_data["phone"] as? String
        
    }

}
