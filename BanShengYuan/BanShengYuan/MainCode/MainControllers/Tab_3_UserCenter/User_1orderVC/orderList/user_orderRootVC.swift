//
//  user_orderRootVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/25.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

let space = 8

let ContentHight = IBScreenHeight - 102

class user_orderRootVC: UIViewController {
    
    @IBOutlet weak var collectionView_top: UICollectionView!
    @IBOutlet weak var scrollV_content: UIScrollView!
    
    var view_undleLine: UIView!
    
    var Page:Int = 0{
        willSet{
            print("Page willSet \(Page)")
        }
        didSet{
            print("Page didSet \(Page)")
        }
    }
    
    let array:[String] = ["全部","待付款","待发货","待收货","已完成","略略略略略略略"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        setupCollectionView()
        
        setScrollViewMain()
        
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "订单"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    设置标题silider
    func setupCollectionView() {
        
        // 1.自定义 Item 的FlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 4.设置 Item 的四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout.minimumLineSpacing = 0
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView_top.collectionViewLayout = flowLayout
        
        collectionView_top.register(UINib.init(nibName: "CCellTop", bundle: nil), forCellWithReuseIdentifier: "CCellTop")
        
        let size = array[0].getLabSize(font: FontLabelPFLight(size: 14))
        
        let width:Int = Int(size.width) + 20
        
        view_undleLine = UIView.init(frame: CGRect.init(x: space, y: 34, width: width-(2*space), height: Int(1.5)))
        
        view_undleLine.backgroundColor = UIColor.blue
        
        collectionView_top.addSubview(view_undleLine)
        
    }
    
    //    设置内容页面
    func setScrollViewMain(){
        
        scrollV_content.contentSize = CGSize.init(width: IBScreenWidth*CGFloat(array.count), height: ContentHight)
        
        for num in 1...array.count{
            
            switch num {
            case 1:
                //我的订单
                let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_OrderVC") as! user_OrderVC
                self.addChildViewController(Vc)
                Vc.view.frame = CGRect.init(x: IBScreenWidth*CGFloat(num-1), y: 0, width: IBScreenWidth, height: ContentHight)
                scrollV_content.addSubview(Vc.view)
            default:
                let view = UIView.init(frame: CGRect.init(x: IBScreenWidth*CGFloat(num-1), y: 0, width: IBScreenWidth, height: ContentHight))
                view.backgroundColor = AnyColor(alpha: 0.9)
                scrollV_content.addSubview(view)
            }
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension user_orderRootVC:UIScrollViewDelegate{
    
    func scrollviewScroll(toPage:Int){
        scrollV_content.scrollRectToVisible(CGRect.init(x: CGFloat(toPage) * IBScreenWidth, y: 0, width: IBScreenWidth, height: ContentHight), animated: false)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if scrollView == scrollV_content{
            
            let offsetX = scrollView.contentOffset.x
            
            print("offsetX = \(offsetX) ")
            
            let page = Int(offsetX)/375
            
            if page == Page {
                return
            }else{
                Page = page
                
                topScroll(toItem: Page)
            }
            
            
        }
        
    }
}

extension user_orderRootVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        scrollviewScroll(toPage: indexPath.row)
    }
    
    func topScroll(toItem:Int){
        
        let indexPath = IndexPath.init(row: toItem, section: 0)
        
        self.collectionView_top.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let cell = collectionView_top.cellForItem(at: indexPath)
        
        if let frame = cell?.frame{
            
            let rect = collectionView_top.convert(frame, from: collectionView_top)
            
            let size = array[toItem].getLabSize(font: FontLabelPFLight(size: 14))
            
            let width:Int = Int(size.width) + 20
            
            UIView.animate(withDuration: 0.4) {
                
                self.view_undleLine.frame.size.width = CGFloat(width-space*2)
                
                self.view_undleLine.frame.origin.x = rect.origin.x + CGFloat(space)
                
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
}

extension user_orderRootVC:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return array.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellTop", for: indexPath) as! CCellTop
        
        cell.label_txt.text = array[indexPath.row]
        
//        cell.layoutIfNeeded()
        
        return cell
        
    }
    
}


extension user_orderRootVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size = array[indexPath.row].getLabSize(font: FontLabelPFLight(size: 14))
        
        let width:Int = Int(size.width) + 20
        
        return CGSize.init(width: width, height: 36)

    }
    
}
