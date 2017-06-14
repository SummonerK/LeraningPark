//
//  ScrollViewIBHome.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ScrollViewIBHome: UIScrollView {
    
    open var arrayImages:[String]? = ["PIC","PIC","PIC"]
    
    let page = UIPageControl()
    
    var Hight:CGFloat? = 0
    
    
    @IBInspectable var HIGHT : CGFloat = 0{
        didSet{
            Hight = HIGHT
        }
    }
    
    override func awakeFromNib() {
        creatMyScrollView(imageName: arrayImages!, height: Hight!)
    }
    
    func creatMyScrollView(imageName:[String],height:CGFloat) {
        //动态布局
        for i in 0...(imageName.count - 1) {
            let imageView = UIImageView(frame: CGRect.init(x: CGFloat(i) * IBScreenWidth, y: 0, width: IBScreenWidth, height: height))
            self.addSubview(imageView)
            
            //设置轮播图图片
            imageView.image = UIImage(named: imageName[i])
        }
        //设置轮播图容量
        self.contentSize = CGSize.init(width: CGFloat(imageName.count ) * IBScreenWidth, height: height)
        //设置吸附属性
        self.bounces = false
        //设置书页效果
        self.isPagingEnabled = true
        
        //单独创建第n+1张轮播图，和第一张图片是同一张图
        let imageView = UIImageView(frame:CGRect.init(x: CGFloat(imageName.count) * IBScreenWidth, y: 0, width: IBScreenWidth, height: height))
        imageView.image = UIImage(named:imageName[0])
        self.addSubview(imageView)
        
        page.frame = CGRect.init(x: IBScreenWidth / 2 - 50, y: 160, width: 100, height: 30)
        page.numberOfPages = (arrayImages?.count)!
        self.addSubview(page)
        
    }
    
    func creatTimer() {
        let  timer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerManager), userInfo: nil, repeats: true)
        
        //这句话实现多线程，如果你的ScrollView是作为TableView的headerView的话，在拖动tableView的时候让轮播图仍然能轮播就需要用到这句话
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
    }
    
    //创建定时器管理者
    func timerManager() {
        //设置偏移量scr.setContentOffset(CGPointMake(scr.contentOffset.x + width, 0), animated: true)
        //当偏移量达到最后一张的时候，让偏移量置零
        if self.contentOffset.x == CGFloat(IBScreenWidth) * CGFloat((arrayImages?.count)!) {
            self.contentOffset = CGPoint.init(x: 0, y: 0)
        }
        
    }

}

var cnt = 0

extension ScrollViewIBHome:UIScrollViewDelegate{
    
    //当手动滚动视图翻页时调用该方法
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cPage = self.contentOffset.x / IBScreenWidth
        page.currentPage = Int(cPage)
        cnt = Int(cPage)
    }
    
    //自动播放时，调用该方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cnt += 1
        page.currentPage = cnt % (arrayImages?.count)!
    }
}
