//
//  Activity_RootVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/9.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import Kingfisher

class Activity_RootVC: UIViewController {
    
    @IBOutlet weak var tableV_main: UITableView!
    
    var viewheader:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "精彩活动"
        
        tableV_main.register(UINib.init(nibName: "TCellActivity", bundle: nil), forCellReuseIdentifier: "TCellActivity")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension Activity_RootVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath) as! TCellActivity
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let url = URL(string: urlStr)
        
        cell.imageV_activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
}

extension Activity_RootVC: UITableViewDelegate {
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        
//        return (section==0) ? 130 : 0
//        
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//
//        viewheader = UIView()
//        viewheader?.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: 64)
//        viewheader?.backgroundColor = UIColor.blue
//        return viewheader
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return IBScreenWidth*176/375
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TCellActivity else {
            return
        }
        
    }
}
