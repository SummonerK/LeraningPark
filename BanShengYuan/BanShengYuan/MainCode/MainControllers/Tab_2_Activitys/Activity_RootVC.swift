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
    
    let array_image:[(String,String)]! = [("activity3","subactivity3"),("activity2","subactivity2"),("activity1","subactivity1")]
    
    var viewheader:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FlatWhiteLight
        
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
        return array_image.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath) as! TCellActivity
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.imageV_activity.image = BundleImageWithName(array_image[indexPath.section].1)
        
//        let url = URL(string: urlStr)
//        
//        cell.imageV_activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
}

extension Activity_RootVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
//        return (section==0) ? 130 : 0
        
        return 10
        
    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//
//        viewheader = UIView()
//        viewheader?.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: 64)
//        viewheader?.backgroundColor = UIColor.blue
//        return viewheader
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
//        
//        return (section==array_image.count-1) ? 0 : 10
//    }
    
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
