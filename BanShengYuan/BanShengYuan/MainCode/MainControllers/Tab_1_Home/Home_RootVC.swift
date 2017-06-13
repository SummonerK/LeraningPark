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
    
    var viewheader:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableV_main.register(UINib.init(nibName: "TCellActivity", bundle: nil), forCellReuseIdentifier: "TCellActivity")
        tableV_main.register(UINib.init(nibName: "TCell_Footer", bundle: nil), forCellReuseIdentifier: "TCell_Footer")
//        tableV_main.register(HomeHeaderV.self, forHeaderFooterViewReuseIdentifier: "HomeHeaderV")
        
        
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
            return IBScreenHeight*0.4
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
        
//        guard let cell = tableView.cellForRow(at: indexPath) as? TCellActivity else {
//            return
//        }
        
    }
}


var key: String = "coverView"

extension UINavigationBar {
    
    /// 定义的一个计算属性，如果可以我更希望直接顶一个存储属性。它用来返回和设置我们需要加到
    /// UINavigationBar上的View
    var coverView: UIView? {
        get {
            //这句的意思大概可以理解为利用key在self中取出对应的对象,如果没有key对应的对象就返回niu
            return objc_getAssociatedObject(self, &key) as? UIView
        }
        
        set {
            //与上面对应是重新设置这个对象，最后一个参数如果学过oc的话很好理解，就是代表这个newValue的属性
            //OBJC_ASSOCIATION_RETAIN_NONATOMIC意味着:strong,nonatomic
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setMyBackgroundColor(_ color: UIColor) {
        
        if self.coverView != nil {
            self.coverView!.backgroundColor = color
        }else {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            let view = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: self.bounds.height + 20))
            view.isUserInteractionEnabled = false
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.insertSubview(view, at: 0)
            
            view.backgroundColor = color
            self.coverView = view
        }
    }
    
    func setMyBackgroundColorAlpha(_ alpha: CGFloat) {
        
        guard let coverView = self.coverView else {
            return
        }
        self.coverView!.backgroundColor = coverView.backgroundColor?.withAlphaComponent(alpha)
    }
}
