//
//  aboutUsVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class aboutUsVC: UIViewController {
    
    @IBOutlet weak var imageV_Header: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavi()
        
        setRadiusFor(toview: imageV_Header, radius: 8, lineWidth: 0, lineColor: FlatWhiteLight)

        // Do any additional setup after loading the view.
    }
    
    func setNavi() {
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        
        self.navigationItem.title = "关于我们"
        
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
