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
    
    let array_image:[(String,String)]! = [("activity3","subactivity3"),("activity2","subactivity2"),("activity1","subactivity1")]

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavi()
        
        tableView_main.register(UINib.init(nibName: "TCell_pActivity", bundle: nil), forCellReuseIdentifier: "TCell_pActivity")
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "活动"

    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension Home_pActivity:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array_image.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_pActivity", for: indexPath) as! TCell_pActivity
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.imageV_activity.image = BundleImageWithName(array_image[indexPath.section].1)
        
//        let url = URL(string: urlStr)
//        
//        cell.imageV_activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
        
    }
    
}


extension Home_pActivity: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        //        return (section==0) ? 130 : 0
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return IBScreenWidth*176/375
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.section)")
        
        let Vc = StoryBoard_ActivityPages.instantiateViewController(withIdentifier: "activityDetailVC") as! activityDetailVC
        
        Vc.imagename = array_image[indexPath.section].0
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
}
