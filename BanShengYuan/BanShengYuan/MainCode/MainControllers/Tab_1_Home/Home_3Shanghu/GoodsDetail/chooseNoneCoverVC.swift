//
//  chooseNoneCoverVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol chooseNoneCoverVDelegate{
    func chooseNoneClose()
}

class chooseNoneCoverVC: UIViewController {
    
    @IBOutlet weak var view_center: UIView!
    
    var delegate:chooseNoneCoverVDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRadiusFor(toview: view_center, radius: 6, lineWidth: 0, lineColor: UIColor.clear)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCover(_ sender: Any) {
        self.delegate?.chooseNoneClose()
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
