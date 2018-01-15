//
//  ViewController.swift
//  containerView
//
//  Created by Luofei on 2018/1/15.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            firstView.isHidden = false
            secondView.isHidden = true
        case 1:
            firstView.isHidden = true
            secondView.isHidden = false
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView.isHidden = false
        secondView.isHidden = true
        
        combinText()
        
        print("%@",goodMetod(value: "test"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 注释方法测试
    func combinText() {
        
    }
    
    
    
    /// 加密方法
    ///
    /// - Parameter value: 入参 ：String
    /// - Returns: 加密后字串返回 ：String
    /// - 加密规则 ：1、key顺序排列，’key=value&key=value‘相连
    func goodMetod(value:String) -> (String) {
        
        return value
    }


}

