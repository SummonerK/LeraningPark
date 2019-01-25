//
//  WMLogPageVC.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2019/1/24.
//  Copyright © 2019年 FreeMud. All rights reserved.
//

import UIKit

class WMLogPageVC: UIViewController {
    
    @IBOutlet weak var webPage:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let wmPath = IBLFileLogM.IBlogPath(type: .IBLOG_TPYE_WM) else {
            print("未读取到日志")
            return
        }
        
        let file = FileManager.default.contents(atPath: wmPath.path)
        
        print("wmPath = \(wmPath.path)")
        
        webPage.load(file ?? Data(), mimeType: "text/txt", textEncodingName: "UTF-8", baseURL: URL.init(string: "local")!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///返回操作响应
    @IBAction func naviBackAction(_ sender: Any) {
        self.SWDismissScene(animated: true)
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
