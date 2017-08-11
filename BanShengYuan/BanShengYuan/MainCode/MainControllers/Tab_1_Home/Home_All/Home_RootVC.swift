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

import RxSwift
import ObjectMapper
import SwiftyJSON

let urlStr = "http://pic35.photophoto.cn/20150601/0030014594765207_b.jpg"

class Home_RootVC: UIViewController{

    @IBOutlet weak var tableV_main: UITableView!
    
    var shadowImage:UIView?
    
    var viewheader:UIView?
    
    //network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    
    let modelAccess = ModelOrderPayAccessPost()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        HUDcustomShow(toview: self.view)
//        HUDGifCustomShow()
//        if WXApi.isWXAppInstalled(){
//            HUDShowMsgQuick(msg: "检测到微信", toView: KeyWindow, time: 0.8)
//        }else{
//            HUDShowMsgQuick(msg: "未检测到微信", toView: KeyWindow, time: 0.8)
//        }
//        LoginAdjust()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "15600703630"
        
        PrintFM(str.sectoryPhone)
        
        PrintFM(str.fixPrice())
        
//        HUDtextShow(toview: KeyWindow, msg: "支付失败", subMsg: "15600703631")
        
//        modelAccess.orderId = "82240992678248710"
//        
//        OrderM.orderPayAccess(amodel: modelAccess)
//            
//            .subscribe(onNext: { (posts: ModelOrderPayAccessBack) in
//                
//                PrintFM("pictureList\(posts)")
//                
//                if let content = posts.data{
//                    
//                    PrintFM("content = \(content)")
//                }
//                
//            },onError:{error in
//                
//                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
//                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
//                }else{
//                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
//                }
//            })
//            .addDisposableTo(disposeBag)
        
        
//        let biz_content = "app_id=2017071207729556&biz_content=%7b%22out_trade_no%22%3a%22SHT1A1553O1336740803%22%2c%22seller_id%22%3a%22%22%2c%22total_amount%22%3a%220.01%22%2c%22subject%22%3a%22%e5%8d%8a%e7%94%9f%e7%bc%98%22%2c%22goods_detail%22%3a%5b%7b%22goods_id%22%3a%221323%22%2c%22goods_name%22%3a%22%e6%9c%aa%e7%9f%a5%e5%95%86%e5%93%81%22%2c%22quantity%22%3a%221%22%2c%22price%22%3a%2299%22%7d%5d%2c%22store_id%22%3a%22107%22%7d&charset=utf-8&method=alipay.trade.app.pay&notify_url=http%3a%2f%2f115.159.142.32%2fapi%2falipaynotify%2f1553&prod_code=QUICK_MSECURITY_PAY&sign_type=RSA&timestamp=2017-07-14+09%3a39%3a12&version=1.0&sign=NUAMMvKtQdZj8Qrdl3wRqjoFgHk5gq8UlxH4o92Qn3FuO2cyunkve3wY5EbrAvuzvc1X4p5APlRKCnmat1rmzpxREsnTKxawL8HlQs4KESk4CIaRUJkyHnATuLCGbwagcHXuJnL8Pun4sY9hx4SAjmM6O7U%2faFi1Z9nrHJC6Rlc%3d"
//        
//        AlipaySDK.defaultService().payOrder(biz_content, fromScheme: "bsy", callback: {(result) in
//            
//            HUDShowMsgQuick(msg: String(describing: result?.description), toView: self.view, time: 0.8)
//            
//            print("---\(String(describing: result?.description))")
//        })
//        
//        HUDShowMsgQuick(msg: "欢迎来到半生缘", toView: self.view, time: 0.8)
    
//        PrintFM("---1\(String(describing: UserDefaults.standard.value(forKey: "IBKey")))")
//        
//        if let value = UserDefaults.standard.value(forKey: "IBKey") {
//            PrintFM("\(value)")
//        }else{
//            UserDefaults.standard.set("", forKey: "IBKey")
//        }
//
//        let dic_temp = NSMutableDictionary()
//        let dic = ["key":"value"]
//        
//        dic_temp.setValue(dic, forKey: "newkey")
//        
//        PrintFM("---\(dic_temp)")
//
//        PrintFM("---2\(String(describing: UserDefaults.standard.value(forKey: "IBKey")))")
        
        tableV_main.register(UINib.init(nibName: "TCellActivity", bundle: nil), forCellReuseIdentifier: "TCellActivity")
        tableV_main.register(UINib.init(nibName: "TCellHomeActivities", bundle: nil), forCellReuseIdentifier: "TCellHomeActivities")
        tableV_main.register(UINib.init(nibName: "TCell_Footer", bundle: nil), forCellReuseIdentifier: "TCell_Footer")
        
        ShowWelecomeV()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func ShowWelecomeV(){
        
        let welecomeV = GuideView.init(frame: UIScreen.main.bounds)
        
        welecomeV.contentImages = {
            
            let array : Array<UIImage> = [BundleImageWithName("guide1")!,BundleImageWithName("guide2")!,BundleImageWithName("guide3")!]
            
            return array
        }
        
        welecomeV.contentSize = {
            return CGSize.init(width: IBScreenWidth, height: IBScreenHeight)
        }
        
        welecomeV.doneButton = {
            let button : UIButton = UIButton(frame:CGRect.init(x: welecomeV.frame.size.width * 0.1, y: welecomeV.frame.size.height - 50, width: welecomeV.frame.size.width * 0.8, height: 33))
            button.setImage(BundlePngWithName("button_start")!, for:UIControlState.normal)
            return button
        }
        
        welecomeV.showGuideView()
        
    }

}


extension Home_RootVC:MyDelegate{
    func moreActivitiesAction(selected : Bool){
        if selected {
            PrintFM("GetMore")
        }
    }
}

extension Home_RootVC:homeFootDelegate{
    func itemSubIndex(indexPath : Int){
        
        if indexPath == 2 {
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pMusic") as! Home_pMusic
            self.navigationController?.pushViewController(Vc, animated: true)
        }
        
        if indexPath == 1 {
            //品牌
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "shangHu_DetailVC") as! shangHu_DetailVC
            
            Vc.shopStoreCode = "107"
            
            self.navigationController?.pushViewController(Vc, animated: true)
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
            
            cell.imgv_HomeHeader.kf.setImage(with: url, placeholder: createImageWithColor(color: FlatWhiteLight), options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_Footer", for: indexPath) as! TCell_Footer
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellHomeActivities", for: indexPath) as! TCellHomeActivities
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
            
            cell.img_left.image = BundleImageWithName("hbleft")
            cell.img_right_down.image = BundleImageWithName("hbright1")
            cell.img_right_up.image = BundleImageWithName("hbright2")
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}



extension Home_RootVC:HomeHeaderDelegate{
    
    func itemScrollIndex(indexPath : Int){
        if indexPath == 0 {
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "Home_pMusic") as! Home_pMusic
            self.navigationController?.pushViewController(Vc, animated: true)
        }else{
            //品牌
            let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "shangHu_DetailVC") as! shangHu_DetailVC
            
            Vc.shopStoreCode = "107"
            
            self.navigationController?.pushViewController(Vc, animated: true)
        }

    }
    
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
            return max(24, IBScreenHeight - 44 - 84 - (IBScreenWidth*(205+142+176)/375))
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
