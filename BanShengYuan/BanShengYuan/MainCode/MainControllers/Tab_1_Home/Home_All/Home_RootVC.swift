//
//  Home_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import Kingfisher
import MBProgressHUD

let urlStr = "http://pic35.photophoto.cn/20150601/0030014594765207_b.jpg"

class Home_RootVC: UIViewController{

    @IBOutlet weak var tableV_main: UITableView!
    
    var shadowImage:UIView?
    
    var viewheader:UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        HUDShowMsgQuick(msg: "欢迎来到半生缘", toView: self.view, time: 0.8)
//        HUDcustomShow(toview: self.view)
//        HUDGifCustomShow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        PrintFM("---1\(String(describing: UserDefaults.standard.value(forKey: "IBKey")))")
        
        if let value = UserDefaults.standard.value(forKey: "IBKey") {
            PrintFM("\(value)")
        }else{
            UserDefaults.standard.set("", forKey: "IBKey")
        }

        let dic_temp = NSMutableDictionary()
        let dic = ["key":"value"]
        
        dic_temp.setValue(dic, forKey: "newkey")
        
        PrintFM("---\(dic_temp)")

        PrintFM("---2\(String(describing: UserDefaults.standard.value(forKey: "IBKey")))")
        
        tableV_main.register(UINib.init(nibName: "TCellActivity", bundle: nil), forCellReuseIdentifier: "TCellActivity")
        tableV_main.register(UINib.init(nibName: "TCellHomeActivities", bundle: nil), forCellReuseIdentifier: "TCellHomeActivities")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderV", for: indexPath) as! HomeHeaderV
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            let url = URL(string: urlStr)
            
            cell.imgv_HomeHeader.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_Footer", for: indexPath) as! TCell_Footer
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellHomeActivities", for: indexPath) as! TCellHomeActivities
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.img_left.image = BundleImageWithName("hbleft")
            cell.img_right_down.image = BundleImageWithName("hbright1")
            cell.img_right_up.image = BundleImageWithName("hbright2")
            
//            let url = URL(string: urlStr)
//            cell.img_left.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
//            cell.img_right_up.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
//            cell.img_right_down.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension Home_RootVC:HomeHeaderDelegate{
    
    func activitiesAction(path : String){
        
    }
    
    func itemActionWithIndexPath(indexPath : IndexPath){
        
        switch indexPath.row {
        case 0://品牌
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "home_pinPaiVC") as! home_pinPaiVC
            self.navigationController?.pushViewController(Vc, animated: true)
        case 1://活动
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pActivity") as! Home_pActivity
            self.navigationController?.pushViewController(Vc, animated: true)
        case 2://商户
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pShanghu") as! Home_pShanghu
            self.navigationController?.pushViewController(Vc, animated: true)
        case 3://停车
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pParking") as! Home_pParking
            self.navigationController?.pushViewController(Vc, animated: true)
        case 4://魔门音乐
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pMusic") as! Home_pMusic
            self.navigationController?.pushViewController(Vc, animated: true)
        case 5://空中花市
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pHuashi") as! Home_pHuashi
            self.navigationController?.pushViewController(Vc, animated: true)
        case 6://会员积分
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pVip") as! Home_pVip
            self.navigationController?.pushViewController(Vc, animated: true)
        case 7://更多
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pMore") as! Home_pMore
            self.navigationController?.pushViewController(Vc, animated: true)
        default:
            return
        }
        
    }
    
}

extension Home_RootVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 0:
//            return 140+44+(IBScreenWidth*205/375)
            
            return 44+(IBScreenWidth*(205+142)/375)
        case 1:
            return 24
        case 2:
            return IBScreenWidth*176/375
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)")
        
    }
}


var key: String = "coverView"
