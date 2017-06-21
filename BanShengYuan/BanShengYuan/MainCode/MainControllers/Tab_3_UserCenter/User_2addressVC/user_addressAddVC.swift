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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        // Do any additional setup after loading the view.
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = tag_pagefrom==2 ? "编辑收货人" : "新建收货人"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addressAction(_ sender: Any) {
        
        PrintFM("choose Location Address")
        
    }
    

}
