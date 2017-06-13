//
//  Home_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import Kingfisher

let urlStr = "http://pic35.photophoto.cn/20150601/0030014594765207_b.jpg"

class Home_RootVC: UIViewController{

    @IBOutlet weak var tableV_main: UITableView!
    
    var shadowImage:UIView?
    
    var viewheader:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV_main.register(UINib.init(nibName: "TCellActivity", bundle: nil), forCellReuseIdentifier: "TCellActivity")
        tableV_main.register(UINib.init(nibName: "TCell_Footer", bundle: nil), forCellReuseIdentifier: "TCell_Footer")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension Home_RootVC:MyDelegate{
    func moreActivitiesAction(selected : Bool){
        if selected {
            PrintFM("GetMore")
        }
    }
}

extension Home_RootVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderV", for: indexPath) as! HomeHeaderV
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let url = URL(string: urlStr)
            
            cell.imgv_HomeHeader.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath) as! TCellActivity
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let url = URL(string: urlStr)
            
            cell.imageV_activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_Footer", for: indexPath) as! TCell_Footer
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension Home_RootVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
            return IBScreenHeight*0.6
        case 1:
            return IBScreenHeight * 0.12
        case 2:
            return 40
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)")
        
    }
}


var key: String = "coverView"
