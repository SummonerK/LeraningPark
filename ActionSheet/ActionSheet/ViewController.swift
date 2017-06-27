//
//  ViewController.swift
//  ActionSheet
//
//  Created by Luofei on 2017/6/27.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
    }

    func setNavi() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        item.setBackgroundImage(UIImage(named: "arrow_left"), for: UIControlState.normal, barMetrics:UIBarMetrics.compact)
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "个人信息"
        
    }
    
    func actionBack(_ sender: Any) {
        print("back")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showActionSheet(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) -> Void in
            
        })
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    

}

