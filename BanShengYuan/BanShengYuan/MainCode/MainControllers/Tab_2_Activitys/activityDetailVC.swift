//
//  activityDetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/4.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class activityDetailVC: BaseTabHiden {

    @IBOutlet weak var imageV_page: UIImageView!
    
    var imagename:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavi()
        
        imageV_page.image = BundleImageWithName(imagename)
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "活动详细"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
