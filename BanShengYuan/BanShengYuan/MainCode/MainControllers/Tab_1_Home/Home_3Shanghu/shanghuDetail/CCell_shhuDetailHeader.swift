//
//  CCell_shhuDetailHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol shhuDetailHeaderDelegate {
    func SelectedHeadIndex(Index:Int)
}

class CCell_shhuDetailHeader: UICollectionViewCell {
    
    @IBOutlet weak var imageV_icon: UIImageView!
    
    @IBOutlet weak var label_shanghuName: UILabel!
    
    @IBOutlet weak var label_saleCount: UILabel!
    @IBOutlet weak var label_productCount: UILabel!
    
    @IBOutlet weak var bton_xiaoliang: UIButton!
    @IBOutlet weak var line_xiaoliang: UIView!
    
    @IBOutlet weak var bton_price: UIButton!
    @IBOutlet weak var line_price: UIView!
    
    @IBOutlet weak var bton_newProduct: UIButton!
    @IBOutlet weak var line_newProduct: UIView!
    
    @IBOutlet weak var imageV_light: UIImageView!
    
    var delegate:shhuDetailHeaderDelegate!
    
    var test:String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bton_xiaoliang.setTitleColor(UIColor.black, for: UIControlState.normal)
        bton_price.setTitleColor(UIColor.black, for: UIControlState.normal)
        bton_newProduct.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        Selected(bton: bton_xiaoliang)
        
        setRadiusFor(toview: imageV_icon, radius: 3, lineWidth: 0, lineColor: UIColor.clear)
        
    }
    
    @IBAction func action_xiaoliang(_ sender: Any) {
        Selected(bton: bton_xiaoliang)
        self.delegate.SelectedHeadIndex(Index: 0)
    }
    
    @IBAction func action_price(_ sender: Any) {
        Selected(bton: bton_price)
        self.delegate.SelectedHeadIndex(Index: 1)
    }
    
    @IBAction func action_newProduct(_ sender: Any) {
        Selected(bton: bton_newProduct)
        self.delegate.SelectedHeadIndex(Index: 2)
    }
    
    func Selected(bton:UIButton){
        
        if bton == bton_xiaoliang {
            line_xiaoliang.isHidden = false
            line_price.isHidden = true
            line_newProduct.isHidden = true
            
            bton_xiaoliang.setTitleColor(FlatLocalMain, for: UIControlState.normal)
            bton_price.setTitleColor(UIColor.black, for: UIControlState.normal)
            bton_newProduct.setTitleColor(UIColor.black, for: UIControlState.normal)
            
        }
        
        if bton == bton_price{
            line_xiaoliang.isHidden = true
            line_price.isHidden = false
            line_newProduct.isHidden = true
            
            bton_xiaoliang.setTitleColor(UIColor.black, for: UIControlState.normal)
            bton_price.setTitleColor(FlatLocalMain, for: UIControlState.normal)
            bton_newProduct.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        
        if bton == bton_newProduct{
            line_xiaoliang.isHidden = true
            line_price.isHidden = true
            line_newProduct.isHidden = false
            
            bton_xiaoliang.setTitleColor(UIColor.black, for: UIControlState.normal)
            bton_price.setTitleColor(UIColor.black, for: UIControlState.normal)
            bton_newProduct.setTitleColor(FlatLocalMain, for: UIControlState.normal)
        }
        
    }

}
