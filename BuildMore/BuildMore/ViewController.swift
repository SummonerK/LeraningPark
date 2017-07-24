//
//  ViewController.swift
//  BuildMore
//
//  Created by Luofei on 2017/7/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import Foundation

//#if DEBUG
//let msg = "正式环境-debug"
//#else
//let msg = "测试环境—"
//#endif

#if DEBUGDEV
let msg = "测试环境-debug"
#elseif DEBUG
let msg = "正式环境-debug"
#elseif RELEASE
let msg = "正式环境-release"
#elseif RELEASEDEV
let msg = "测试环境-release"
#else
let msg = ""
#endif


class ViewController: UIViewController {

    @IBOutlet weak var label_msg: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label_msg.text = msg
        // Do any additional setup after loading the view, typically from a nib.
    }
                
    @IBAction func printSomething(_ sender: Any) {
        
        print(msg)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

