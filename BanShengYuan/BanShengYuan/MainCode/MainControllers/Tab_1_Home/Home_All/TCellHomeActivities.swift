//
//  TCellHomeActivities.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/13.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol homeFootDelegate{
    func itemSubIndex(indexPath : Int)
}

class TCellHomeActivities: UITableViewCell {
    
    var delegate:homeFootDelegate?
    
    @IBOutlet weak var img_left: UIImageView!
    @IBOutlet weak var img_right_down: UIImageView!
    @IBOutlet weak var img_right_up: UIImageView!
    
    var _tapGesture: UITapGestureRecognizer! //手势

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        img_right_down.addGestureRecognizer(_tapGesture)
    }
    
    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            self.delegate?.itemSubIndex(indexPath: 2)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
