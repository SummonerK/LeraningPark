//
//  Login_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit

class Login_RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        PrintFM("登录")
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let storyboard_HOME = UIStoryboard.init(name: "Main", bundle: nil)
        window?.rootViewController = storyboard_HOME.instantiateInitialViewController()
        
        UIApplication.shared.keyWindow?.layer
        
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
