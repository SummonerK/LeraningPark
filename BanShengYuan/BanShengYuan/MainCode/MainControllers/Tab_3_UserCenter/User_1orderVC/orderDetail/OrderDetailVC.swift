//
//  OrderDetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/5.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {

    @IBOutlet weak var tableV_main: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        tableV_main.register(UINib.init(nibName: "TCell_UserOrder", bundle: nil), forCellReuseIdentifier: "TCell_UserOrder")
        tableV_main.register(UINib.init(nibName: "TCellPostInfo", bundle: nil), forCellReuseIdentifier: "TCellPostInfo")
        tableV_main.register(UINib.init(nibName: "TCellOrderInfo", bundle: nil), forCellReuseIdentifier: "TCellOrderInfo")
        
        tableV_main.backgroundColor = FlatWhiteLight
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "订单详细"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension OrderDetailVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if section == 0{
            let viewheader = Bundle.main.loadNibNamed("view_orderEndHeader", owner: nil, options: nil)?.first as? view_orderEndHeader
            
            //        viewheader?.label_dianpuname.text = "一家店铺"
            //        viewheader?.label_wuliu.text = "已出库"
            
            return viewheader
        }else{
            return nil
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        if section == 0{
            let viewfooter = Bundle.main.loadNibNamed("view_orderEndFooter", owner: nil, options: nil)?.first as? view_orderEndFooter
            
            return viewfooter
        }else{
            return nil
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_UserOrder", for: indexPath) as! TCell_UserOrder
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellPostInfo", for: indexPath) as! TCellPostInfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellOrderInfo", for: indexPath) as! TCellOrderInfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
            
        default :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellOrderInfo", for: indexPath) as! TCellOrderInfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
            
        }
        
    }
    
}

extension OrderDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 0{
            return 135
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 0{
            return 130
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 203
        case 2:
            return 188
        default :
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}

