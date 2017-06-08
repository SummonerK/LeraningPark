//
//  getResetCodeVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/8.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class getResetCodeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let duration = 0.3

    @IBAction func goToResetVC(_ sender: Any) {
        
        let resetVc = self.storyboard?.instantiateViewController(withIdentifier: "resetPwdVC") as! resetPwdVC
        
        self.present(resetVc, animated: false, completion: nil)
        
        let animation = CATransition.init()
        animation.duration = duration
        //        animation.type = "rippleEffect" //波纹
        animation.type = kCATransitionFade 
        
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)

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
