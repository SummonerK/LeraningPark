//
//  info_SexVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/27.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

typealias sexBack =  (_ back:String) -> Void

class info_SexVC: UIViewController {

    var sexBack:sexBack?
    
    var sexChoose:String?
    
    @IBOutlet weak var bton_man: UIButton!
    
    @IBOutlet weak var bton_woman: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setNavi()
        
        if let nick = sexChoose {
            if nick == "1" {
                bton_man.setBackgroundImage(createImageWithColor(color: FlatLocalMain), for: UIControlState.normal)
                bton_woman.setBackgroundImage(createImageWithColor(color: UIColor.white), for: UIControlState.normal)
            }
            
            if nick == "2" {
                bton_woman.setBackgroundImage(createImageWithColor(color: FlatLocalMain), for: UIControlState.normal)
                bton_man.setBackgroundImage(createImageWithColor(color: UIColor.white), for: UIControlState.normal)
            }
        }
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        self.navigationItem.leftBarButtonItem = item
        
        let item_r = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(actionSave(_:)))
        self.navigationItem.rightBarButtonItem = item_r
        
        self.navigationItem.title = "编辑性别"
    }
    
    func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionSave(_ sender: Any) {
        
        sexBack!(sexChoose!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseMan(_ sender: Any) {
        PrintFM("choose")
        sexChoose = "1"
        bton_man.setBackgroundImage(createImageWithColor(color: FlatLocalMain), for: UIControlState.normal)
        bton_woman.setBackgroundImage(createImageWithColor(color: UIColor.white), for: UIControlState.normal)
    }

    @IBAction func chooseWoman(_ sender: Any) {
        PrintFM("choose")
        sexChoose = "2"
        bton_woman.setBackgroundImage(createImageWithColor(color: FlatLocalMain), for: UIControlState.normal)
        bton_man.setBackgroundImage(createImageWithColor(color: UIColor.white), for: UIControlState.normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
