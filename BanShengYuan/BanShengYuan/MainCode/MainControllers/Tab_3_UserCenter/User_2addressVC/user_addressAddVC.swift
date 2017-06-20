//
//  user_addressAddVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/20.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_addressAddVC: UIViewController {
    
    var tag_pagefrom:Int? = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = tag_pagefrom==2 ? "编辑收货人" : "新建收货人"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addressAction(_ sender: Any) {
        
        PrintFM("choose Location Address")
        
    }
    

}
