//
//  Home_pActivity.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import DZNEmptyDataSet


class Home_pActivity: BaseTabHiden {
    
    @IBOutlet weak var tableView_main: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "活动"
        
        tableView_main.register(UINib.init(nibName: "TCell_pActivity", bundle: nil), forCellReuseIdentifier: "TCell_pActivity")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension Home_pActivity:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_pActivity", for: indexPath) as! TCell_pActivity
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let url = URL(string: urlStr)
        
        cell.imageV_activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
        
    }
    
}


extension Home_pActivity: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return IBScreenWidth*176/375
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)")
        
    }
}
