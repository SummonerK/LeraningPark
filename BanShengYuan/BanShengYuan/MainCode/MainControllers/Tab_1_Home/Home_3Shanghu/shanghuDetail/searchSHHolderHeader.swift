//
//  searchSHHolderHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class searchSHHolderHeader: UICollectionViewCell {
    
    @IBOutlet weak var bton_searchDelete: UIButton!
    
    @IBOutlet weak var label_name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func search_delete(_ sender: Any) {
        PrintFM("")
    }

}
