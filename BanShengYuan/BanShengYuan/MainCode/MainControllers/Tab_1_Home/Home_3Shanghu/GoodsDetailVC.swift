//
//  GoodsDetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class GoodsDetailVC: BaseTabHiden {

    @IBOutlet weak var tableV_main: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableV_main.register(UINib.init(nibName: "TCellGoodsinfo", bundle: nil), forCellReuseIdentifier: "TCellGoodsinfo")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension GoodsDetailVC:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return (section==0) ? IBScreenWidth*276/375 : 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let imageArray = [
            "http://wx3.sinaimg.cn/mw690/62eeaba5ly1fee5yt59wrj20fa08lafr.jpg",
            "http://wx4.sinaimg.cn/mw690/6a624f11ly1fed4bwlbb0j20go0h6q5h.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            "http://wx2.sinaimg.cn/mw690/af0d43ddgy1fdjzefvub1j20dw09q48s.jpg"
        ]
        
        let viewheader = view_shanghuHeader.init(frame: CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth*176/375))
        
        viewheader.contentImages = {
            
            return imageArray
        }
        
        return viewheader
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsinfo", for: indexPath) as! TCellGoodsinfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension GoodsDetailVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return IBScreenWidth*110/375
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //品牌
        let storyboard = UIStoryboard.init(name: "NextPages_FromHome", bundle: nil)
        let Vc = storyboard.instantiateViewController(withIdentifier: "shangHu_DetailVC") as! shangHu_DetailVC
        self.navigationController?.pushViewController(Vc, animated: true)
        
        PrintFM("\(indexPath.row)")
        
    }
}
