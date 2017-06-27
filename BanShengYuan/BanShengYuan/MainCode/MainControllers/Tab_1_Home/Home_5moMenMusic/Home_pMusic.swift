//
//  Home_pMusic.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class Home_pMusic: BaseTabHiden {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "魔门音乐"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
