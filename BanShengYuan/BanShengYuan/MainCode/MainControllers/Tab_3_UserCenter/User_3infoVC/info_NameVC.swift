//
//  info_NameVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/27.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

typealias nickNameBack =  (_ back:String) -> Void

class info_NameVC: UIViewController {
    
    var nickNameBack:nickNameBack?
    
    @IBOutlet weak var tf_nickName: UITextField!
    
    var nickName:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        
        setNavi()
        
        if let nick = nickName {
            tf_nickName.text = nick
        }
        
        super.viewDidLoad()

    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        self.navigationItem.leftBarButtonItem = item
        
        let item_r = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(actionSave(_:)))
        self.navigationItem.rightBarButtonItem = item_r
        
        self.navigationItem.title = "编辑昵称"
        
    }

    func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionSave(_ sender: Any) {
        
        if let editname = tf_nickName.text {
            nickNameBack!(editname)
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
