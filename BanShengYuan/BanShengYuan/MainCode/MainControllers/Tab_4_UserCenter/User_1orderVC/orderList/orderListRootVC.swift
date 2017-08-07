//
//  orderListRootVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/28.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import SnapKit

class orderListRootVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var collectionView_top: UICollectionView!
    
    var tableV_cantent:UITableView!
    
    var ItemW:Int = 0
    
    var view_undleLine: UIView!
    
    var Page:Int = 0
    
    let array:[String] = ["全部","待发货(2)","配送中(1)","已完成"]
    
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
        
        setupTableViewContent()

    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "订单"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
        
//        view_undleLine = UIView.init(frame: CGRect.init(x: CGFloat(normalSpace) + 1.5, y: 34.0, width: width, height: CGFloat(1.8)))
        
        view_undleLine = UIView.init(frame: CGRect.init(x: CGFloat(normalSpace) + 1, y: CGFloat(34.0), width: CGFloat(width), height: CGFloat(1.8)))
        
        view_undleLine.backgroundColor = FlatLocalMain
        
        collectionView_top.addSubview(view_undleLine)
        
    }
    
    func setupTableViewContent() {
        
        tableV_cantent = UITableView()
        
        self.view.addSubview(tableV_cantent)
        
        tableV_cantent.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(54)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: IBScreenHeight-108, height: IBScreenWidth))
        }
        
        tableV_cantent.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi/2))
        tableV_cantent.isPagingEnabled = true
        tableV_cantent.separatorStyle = UITableViewCellSeparatorStyle.none
        tableV_cantent.delegate = self
        tableV_cantent.dataSource = self
        tableV_cantent.showsVerticalScrollIndicator = false
        tableV_cantent.showsHorizontalScrollIndicator = false
        
        tableV_cantent.register(UINib.init(nibName: "TCellOrderContent", bundle: nil), forCellReuseIdentifier: "TCellOrderContent")
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //#Mark:-DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellOrderContent", for: indexPath) as! TCellOrderContent
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if indexPath.row == 0{
            cell.getOrderList()
        }else{
            cell.setDefaultNoneData()
        }
        
        return cell
        
    }
    
    //#Mark:-delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return IBScreenWidth
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }

}


extension orderListRootVC:UICollectionViewDelegate{
    
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
                
                self.view_undleLine.frame.origin.x = rect.origin.x + CGFloat(normalSpace) + 1
                
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
}

extension orderListRootVC:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellTop", for: indexPath) as! CCellTop
        
        cell.label_txt.text = array[indexPath.row]
        
        return cell
        
    }
    
}


extension orderListRootVC:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize.init(width: ItemW, height: 36)
        
    }
    
}

extension orderListRootVC:UIScrollViewDelegate{
    
    func scrollviewScroll(toPage:Int){
        
        tableV_cantent.scrollRectToVisible(CGRect.init(x: 0, y: CGFloat(toPage) * IBScreenWidth, width: ContentHight, height: IBScreenWidth), animated: false)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if scrollView == tableV_cantent{
            
            let offsetX = scrollView.contentOffset.y
            
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
