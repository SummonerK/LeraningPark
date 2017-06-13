//
//  TCell_Footer.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol MyDelegate{
    func moreActivitiesAction(selected : Bool)
}

class TCell_Footer: UITableViewCell {

    var delegate:MyDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreActivities(_ sender: Any) {
        
        self.delegate?.moreActivitiesAction(selected: true)
        
    }
    
}
