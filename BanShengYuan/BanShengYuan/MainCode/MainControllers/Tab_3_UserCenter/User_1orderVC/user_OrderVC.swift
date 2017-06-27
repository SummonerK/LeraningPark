//
//  user_OrderVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_OrderVC: BaseTabHiden {
    @IBOutlet weak var tableV_main: UITableView!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = FlatWhiteLight
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "我的订单"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension user_OrderVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("view_orderHeader", owner: nil, options: nil)?.first as? view_orderHeader
        
        viewheader?.label_dianpuname.text = "一家店铺"
        viewheader?.label_wuliu.text = "已出库"
        
        return viewheader
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_UserOrder", for: indexPath) as! TCell_UserOrder
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //            cell.label_title.text = array_title?[indexPath.row]
        
        return cell
        
    }
    
}

extension user_OrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 6
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 110
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}


