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
        imageV_Header.layer.cornerRadius = IBScreenWidth*176/375*0.7/2
        imageV_Header.layer.borderColor = UIColor.white.cgColor
        imageV_Header.layer.borderWidth = 2
        imageV_Header.layer.masksToBounds = true
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
