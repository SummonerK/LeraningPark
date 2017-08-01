//
//  ViewController.swift
//  BuildMore
//
//  Created by Luofei on 2017/7/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import Foundation

//#if DEBUG
//let msg = "正式环境-debug"
//#else
//let msg = "测试环境—"
//#endif

#if DEBUGDEV
let msg = "测试环境-debug"
#elseif DEBUG
let msg = "正式环境-debug"
#elseif RELEASE
let msg = "正式环境-release"
#elseif RELEASEDEV
let msg = "测试环境-release"
#else
let msg = ""
#endif

let space = 8

/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height;
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width;

func FontLabelPFLight(size:CGFloat)->UIFont{
    
    return UIFont(name: "PingFangSC-Light", size: size)!
    
}

func AnyColor(alpha:CGFloat)->UIColor{
    let anycolor = UIColor.init(hue: (CGFloat(Float(arc4random()%256) / 256.0)), saturation: (CGFloat(Float(arc4random()%256) / 256.0)), brightness: (CGFloat(Float(arc4random()%256) / 256.0)), alpha: alpha)
    return anycolor
}


class ViewController: UIViewController{

    @IBOutlet weak var label_msg: UILabel!
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
    
    
    let array:[String] = ["科学","今日头条","海外趣闻","生化工程科学篇","诗","今日头条","海外趣闻","生化工程科学篇","诗"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label_msg.text = msg
        
        setupCollectionView()
        
        setScrollViewMain()
        
    }
                
    @IBAction func printSomething(_ sender: Any) {
        
        label_msg.shake(direction: .horizontal, times: 5, interval: 0.2, delta: 8) {
            print("shake")
        }
        
        print(msg)
        
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
        
        view_undleLine = UIView.init(frame: CGRect.init(x: space, y: 28, width: width-(2*space), height: Int(1.5)))
        
        view_undleLine.backgroundColor = UIColor.blue
        
        collectionView_top.addSubview(view_undleLine)
        
    }
    
//    设置内容页面
    func setScrollViewMain(){
        scrollV_content.contentSize = CGSize.init(width: IBScreenWidth*CGFloat(array.count), height: 210)
        
        for num in 1...array.count{
            let view = UIView.init(frame: CGRect.init(x: IBScreenWidth*CGFloat(num-1), y: 0, width: IBScreenWidth, height: 210))
            view.backgroundColor = AnyColor(alpha: 0.9)
            scrollV_content.addSubview(view)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UIScrollViewDelegate{
    
    func scrollviewScroll(toPage:Int){
        scrollV_content.scrollRectToVisible(CGRect.init(x: CGFloat(toPage) * IBScreenWidth, y: 0, width: IBScreenWidth, height: 210), animated: false)
        
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

extension ViewController:UICollectionViewDelegate{
    
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

extension ViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return array.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == collectionView_top {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellTop", for: indexPath) as! CCellTop
            
            cell.label_txt.text = array[indexPath.row]
            
            cell.layoutIfNeeded()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellContent", for: indexPath) as! CCellContent
        
        cell.label_txt.text = array[indexPath.row]
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    
}


extension ViewController:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size = array[indexPath.row].getLabSize(font: FontLabelPFLight(size: 14))
        
        let width:Int = Int(size.width) + 20
        
        return CGSize.init(width: width, height: 30)
        
        
    }
    
}

extension String{
    //计算字串宽高
    func getLabSize(font:UIFont) -> CGSize {
        
        let statusLabelText: NSString = self as NSString
        
        let size = CGSize.init(width: 900, height: 22)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        
        return strSize
    }
}

