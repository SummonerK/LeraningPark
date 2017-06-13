//
//  ViewController.swift
//  RoundLF
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height;
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width;

let radius:CGFloat = 40

class ViewController: UIViewController {

    @IBOutlet weak var bton_center: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

