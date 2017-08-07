//
//  TabMallCarVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class TabMallCarVC: UIViewController {

    @IBOutlet weak var table_main: UITableView!
    
    @IBOutlet weak var label_totalprice: UILabel!
    
    @IBOutlet weak var bton_allchoose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bton_allchoose.setImage(UIImage.init(named: "choose_s"), for: .selected)

        setNavi()
        
        table_main.register(UINib.init(nibName: "TCellMallCar", bundle: nil), forCellReuseIdentifier: "TCellMallCar")
        
        table_main.backgroundColor = FlatWhiteLight
        
        table_main.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavi() {
//        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
//        item.image = UIImage(named: "arrow_left")
//        
//        self.navigationItem.leftBarButtonItem = item
        
        self.navigationItem.title = "我的购物车"
        
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionAllChoose(_ sender: Any) {
        
        if bton_allchoose.isSelected {
            bton_allchoose.isSelected = false
        }else{
            bton_allchoose.isSelected = true
        }
        
    }
    
    @IBAction func action_PayNow(_ sender: Any) {
    }

}

extension TabMallCarVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("ViewMallCarHeader", owner: nil, options: nil)?.first as? ViewMallCarHeader
        
        return viewheader
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellMallCar", for: indexPath) as! TCellMallCar
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
}


extension TabMallCarVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}

