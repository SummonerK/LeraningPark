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

func FontLabelPFLight(size:CGFloat)->UIFont{
    
    return UIFont(name: "PingFangSC-Light", size: size)!
    
}


class ViewController: UIViewController {

    @IBOutlet weak var label_msg: UILabel!
    @IBOutlet weak var collectionView_top: UICollectionView!
    @IBOutlet weak var view_content: UIView!
    
    var view_undleLine: UIView!
    
    
    let array:[String] = ["科学","今日头条","海外趣闻","生化工程科学篇","诗","今日头条","海外趣闻","生化工程科学篇","诗"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label_msg.text = msg
        
        setupCollectionView()
        
    }
                
    @IBAction func printSomething(_ sender: Any) {
        
        print(msg)
        
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
//        collectionView_top.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        print("\(indexPath.row)")
        
        topScroll(toItem: indexPath.row)
        
    }
    
    func topScroll(toItem:Int){
        
        let indexPath = IndexPath.init(row: toItem, section: 0)
        
        let cell = collectionView_top.cellForItem(at: indexPath)
        
        let rect = collectionView_top.convert((cell?.frame)!, from: collectionView_top)
        
        let size = array[toItem].getLabSize(font: FontLabelPFLight(size: 14))
        
        let width:Int = Int(size.width) + 20
        
        UIView.animate(withDuration: 0.4) {
            
            self.view_undleLine.frame.size.width = CGFloat(width-space*2)
            
            self.view_undleLine.frame.origin.x = rect.origin.x + CGFloat(space)
            
            self.view.layoutIfNeeded()
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

