//
//  ViewController.swift
//  RootPrint
//
//  Created by Luofei on 2018/10/24.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coverItemVC: BLEListVC! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCoverView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showBLEListV() -> Void {
        print("showBLEListV")
        showCoverView()
    }
    
    func showBLEChaListV() -> Void {
        print("showBLEChaListV")
    }
    
    func setCoverView(){
        
        coverItemVC = BLEListVC(nibName: "BLEListVC", bundle: nil)
        
        self.addChildViewController(coverItemVC)
        
        coverItemVC.view.frame = self.view.frame
        
        self.view.addSubview(coverItemVC.view)
        
        self.view.sendSubview(toBack: coverItemVC.view)
        
        coverItemVC.view.isHidden = true
        
    }
    
    func showCoverView() {
        
        coverItemVC.view.isHidden = false
        self.view.bringSubview(toFront: coverItemVC.view)
    }
    
    func closeCoverView() {
        coverItemVC.view.isHidden = true
        self.view.sendSubview(toBack: coverItemVC.view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showBLEViews(_ sender: Any) {
        
//        (self.navigationController as! RootNaviC).showBLEListV()
//        
//        (self.navigationController as! RootNaviC).showBLEChaListV()
        
        showBLEListV()
    }

}

