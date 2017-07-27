//
//  user_orderMenu.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/27.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

let space = 4

let ContentHight = CGFloat(667.0 - 102)

class user_orderMenu: UIViewController{
    
    @IBOutlet weak var collectionView_top: UICollectionView!
    
    @IBOutlet weak var collectionView_content: UICollectionView!
    
    var ItemW:Int = 0
    
    var view_undleLine: UIView!
    
    var Page:Int = 0
    
    let array:[String] = ["全部","待付款","待发货","待收货","已完成"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setNavi()
        
        PrintFM("IBScreen = \(self.view.frame)")
        
        let numPreRow = array.count
        ItemW = (Int(IBScreenWidth) - 2*(numPreRow + 1))/numPreRow
        
        setupCollectionView()

        // Do any additional setup after loading the view.
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
        let width:Int = Int(size.width) + space*2
        let normalSpace = (ItemW - width)/2
        
        view_undleLine = UIView.init(frame: CGRect.init(x: normalSpace, y: 34, width: width, height: Int(1.8)))
        
        view_undleLine.backgroundColor = UIColor.blue
        
        collectionView_top.addSubview(view_undleLine)
        
        
        // 1.自定义 Item 的FlowLayout
        let flowLayout1 = UICollectionViewFlowLayout()
        
        flowLayout1.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 4.设置 Item 的四周边距
        flowLayout1.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // 5.设置同一竖中上下相邻的两个 Item 之间的间距
        flowLayout1.minimumLineSpacing = 0
        // 6.设置同一行中相邻的两个 Item 之间的间距
        flowLayout1.minimumInteritemSpacing = 0
        
        collectionView_content.collectionViewLayout = flowLayout1
        
        collectionView_content.register(UINib.init(nibName: "CCellMenuContent", bundle: nil), forCellWithReuseIdentifier: "CCellMenuContent")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension user_orderMenu:UIScrollViewDelegate{
    
    func scrollviewScroll(toPage:Int){
        collectionView_content.scrollRectToVisible(CGRect.init(x: CGFloat(toPage) * IBScreenWidth, y: 0, width: IBScreenWidth, height: ContentHight), animated: false)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if scrollView == collectionView_content{
            
            let offsetX = scrollView.contentOffset.x
            
//            print("offsetX = \(offsetX) ")
            
            let page = Int(offsetX)/Int(IBScreenWidth)
            
            if page == Page {
                return
            }else{
                Page = page
                PrintFM("Page = \(page)")
                topScroll(toItem: Page)
                
            }
            
        }
        
    }
}

extension user_orderMenu:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        PrintFM("did selected \(indexPath.row)")
        if collectionView == collectionView_top {
            scrollviewScroll(toPage: indexPath.row)
        }

    }
    
    func topScroll(toItem:Int){
        
        PrintFM("Page = \(toItem)")
        
        let indexPath = IndexPath.init(row: toItem, section: 0)
        
        self.collectionView_top.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let cell = collectionView_top.cellForItem(at: indexPath)
        
        if let frame = cell?.frame{
            
            let rect = collectionView_top.convert(frame, from: collectionView_top)
            
            let size = array[toItem].getLabSize(font: FontLabelPFLight(size: 14))
            
            let width:Int = Int(size.width) + space*2
            
            let normalSpace = (ItemW - width)/2
            
            UIView.animate(withDuration: 0.4) {
                
                self.view_undleLine.frame.size.width = CGFloat(width)
                
                self.view_undleLine.frame.origin.x = rect.origin.x + CGFloat(normalSpace)
                
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
}

extension user_orderMenu:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == collectionView_top{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellTop", for: indexPath) as! CCellTop
            
            cell.label_txt.text = array[indexPath.row]
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellMenuContent", for: indexPath) as! CCellMenuContent
            
            cell.getOrderList()
            
            return cell
        }

    }
    
}


extension user_orderMenu:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if collectionView == collectionView_top{
            return CGSize.init(width: ItemW, height: 36)
        }else{
            return CGSize.init(width: IBScreenWidth, height: IBScreenHeight - 104)
        }
        
    }
    
}

