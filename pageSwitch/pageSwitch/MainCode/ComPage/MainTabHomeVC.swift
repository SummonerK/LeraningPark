//
//  MainTabHomeVC.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class MainTabHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = "Home"
        self.navigationController?.title = "Home"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionHome_1_1(_ sender: Any) {
        
        let dic = ["key":"presentVC"] as NSDictionary
        
//        self.SWPresentVC("NextPageVC", dic, { (model) in
//            PrintFM("\(model as! String)")
//        })
        
        self.SWGoNextVC("NextPageVC", .swPresent, dic) { (model) in
            PrintFM("\(model as! String)")
        }
        
    }
    
    @IBAction func actionHome_1_2(_ sender: Any) {
        
        let dic = ["key":"pushVC"] as NSDictionary
        
//        self.navigationController?.SWPushVC("NextPageVC", dic, { (model) in
//            PrintFM("\(model as! String)")
//        })
        
        self.SWGoNextVC("NextPageVC", .swPush, dic) { (model) in
            PrintFM("\(model as! String)")
        }
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
