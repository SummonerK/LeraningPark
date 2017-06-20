//
//  user_AddressVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_AddressVC: BaseTabHiden {

    @IBOutlet weak var tableV_main: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的地址"

        tableV_main.register(UINib.init(nibName: "TCell_userAddress", bundle: nil), forCellReuseIdentifier: "TCell_userAddress")
        
    }
    
    @IBAction func AddAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserCenter", bundle: nil)
        //添加地址页面
        let Vc = storyboard.instantiateViewController(withIdentifier: "user_addressAddVC") as! user_addressAddVC
        Vc.tag_pagefrom = 2
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension user_AddressVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_userAddress", for: indexPath) as! TCell_userAddress
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension user_AddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
