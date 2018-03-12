//
//  ViewController.swift
//  EasyBuy
//
//  Created by Luofei on 2018/3/9.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func goToCamera(_ sender: Any) {
        
        let Vc = CamearVC(nibName: "CamearVC", bundle: nil)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(Vc, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

