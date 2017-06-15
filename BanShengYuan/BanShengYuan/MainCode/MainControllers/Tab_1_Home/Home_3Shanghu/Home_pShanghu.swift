//
//  Home_pShanghu.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class Home_pShanghu: BaseTabHiden {
    
    @IBOutlet weak var tableV_main: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "商户"
        
        tableV_main.register(UINib.init(nibName: "TCellshanghuHeader", bundle: nil), forCellReuseIdentifier: "TCellshanghuHeader")
        
        tableV_main.register(UINib.init(nibName: "TCellshanghu", bundle: nil), forCellReuseIdentifier: "TCellshanghu")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension Home_pShanghu:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellshanghuHeader", for: indexPath) as! TCellshanghuHeader
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellshanghu", for: indexPath) as! TCellshanghu
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let url = URL(string: urlStr)
            
            cell.imageV_shanghuIcon.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension Home_pShanghu: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
            return IBScreenWidth*176/375
        case 1:
            return IBScreenWidth*110/375
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)")
        
    }
}
