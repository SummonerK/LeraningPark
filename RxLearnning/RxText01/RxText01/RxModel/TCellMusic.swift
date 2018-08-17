//
//  TCellMusic.swift
//  RxText01
//
//  Created by Luofei on 2018/8/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class TCellMusic: UITableViewCell {
    
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_subtitle: UILabel!
    @IBOutlet weak var view_icon: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
         view_icon.backgroundColor = UIColor.randomColor        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
