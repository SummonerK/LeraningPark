//
//  user_infoVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_infoVC: BaseTabHiden {

    @IBOutlet weak var tableV_main: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的资料"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action Manager
    ///保存个人资料
    @IBAction func saveAction(_ sender: Any) {

        PrintFM("Action")

    }
    
//    //MARK: - Action Manager
//    ///编辑头像
//    @IBAction func HeaderAction(_ sender: Any) {
//        
//        PrintFM("Action")
//        
//    }
//    ///编辑用户名
//    @IBAction func VipAction(_ sender: Any) {
//        
//        PrintFM("Action")
//        
//    }
//    ///编辑昵称
//    @IBAction func nicNameAction(_ sender: Any) {
//        
//        PrintFM("Action")
//        
//    }
//    ///编辑性别
//    @IBAction func sexAction(_ sender: Any) {
//        
//        PrintFM("Action")
//        
//    }
//    ///编辑出生日期
//    @IBAction func birthdayAction(_ sender: Any) {
//        
//        PrintFM("Action")
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
