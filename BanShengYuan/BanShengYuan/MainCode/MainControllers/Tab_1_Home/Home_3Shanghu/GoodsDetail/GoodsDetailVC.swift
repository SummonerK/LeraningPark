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
    
    var coverVC: chooseVC! = nil
    
    var _tapGesture: UITapGestureRecognizer!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
 
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
        
        tableV_main.register(UINib.init(nibName: "TCellGoodsinfo", bundle: nil), forCellReuseIdentifier: "TCellGoodsinfo")
        tableV_main.register(UINib.init(nibName: "TCellGoodsImage", bundle: nil), forCellReuseIdentifier: "TCellGoodsImage")
        
        setCoverView()
        
    }
    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        PrintFM("")
    }
    
    func setCoverView(){
        
        coverVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "chooseVC") as? chooseVC
        
        coverVC.view.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenHeight)
        
        coverVC.delegate = self
        
        self.view.addSubview(coverVC.view)
        
        self.view.sendSubview(toBack: coverVC.view)
        
    }
    
    func showCoverView() {
        
        self.view.bringSubview(toFront: coverVC.view)
    }
    
    func closeCoverView() {
        
        self.view.sendSubview(toBack: coverVC.view)
    }
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension GoodsDetailVC:ChooseCoverVDelegate{
    
    func setAction(actionType:ChooseCoverActionType){
        switch actionType {
        case .ADD:
            PrintFM("")
        case .Fls:
            PrintFM("")
        case .CLOSE:
            PrintFM("")
            closeCoverView()
        }
    }
    
    func buyNowAction(items:NSArray){
        closeCoverView()
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
        self.navigationController?.pushViewController(Vc, animated: true)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsinfo", for: indexPath) as! TCellGoodsinfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsImage", for: indexPath) as! TCellGoodsImage
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
//            let longurl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497878307246&di=2ba97ccfa0be61143a61baa61eee95ba&imgtype=0&src=http%3A%2F%2Fimg.bbs.cnhubei.com%2Fforum%2Fdvbbs%2F2004-4%2F200441915031894.jpg"
//            let url = URL(string: longurl)
//            
//            cell.imageV_content.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.imageV_content.image = UIImage(named: "detail.jpg")
            
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
            return 90
        case 2:
            
            if let image = UIImage(named: "detail.jpg"){
                let hight =  image.size.height / image.size.width * IBScreenWidth
            
                PrintFM("imageHight \(hight)")
                
                return CGFloat(hight)
//                return 1488
            }else{
                return 0
            }
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
        if indexPath.section == 1 {
            showCoverView()
        }
        
    }
}