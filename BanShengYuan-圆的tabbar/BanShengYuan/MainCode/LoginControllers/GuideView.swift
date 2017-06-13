//
//  GuideView.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

let LocalVersionKey = "LocalVersionKey"
let LocalFirstLaunchKey = "LocalFirstLaunchKey"


// MARK: - 成员属性 && 初始化
open class GuideView: UIView {
    /// 返回背景图
    public typealias BackgroundImage = (Void) -> UIImage
    open var sbackgroundImage : BackgroundImage?
    /// 返回每一页需显示的内容图
    public typealias ContentImages = (Void) -> Array<UIImage>
    open var contentImages : ContentImages?
    /// 返回每一页需显示的内容图的大小  默认全屏 注意，这里按照图片的比例
    public typealias ContentSize = (Void) ->CGSize
    open var contentSize : ContentSize?
    /// 返回每一页需显示的标题
    public typealias Titles = (Void) -> Array<String>
    open var titles : Titles?
    /// 返回完成按钮
    public typealias DoneButton = (Void) -> UIButton
    open var doneButton : DoneButton?
    /// 返回完成按钮在纵坐标上的位置比例
    public typealias DoneButtonYLocation = (Void) ->CGFloat
    open var doneButtonYLocation : DoneButtonYLocation?
    
    /// window
    fileprivate lazy var w : UIWindow = {
        let w = UIWindow(frame:UIScreen.main.bounds)
        w.windowLevel = UIWindowLevelNormal
        w.rootViewController = UIViewController()
        w.backgroundColor = UIColor.red
        w.isHidden = false
        return w
    }()
    
    fileprivate lazy var cc_backgroundImage : UIImage? = {
        return self.sbackgroundImage?()
    }()
    
    fileprivate lazy var cc_contentImages : Array<UIImage> = {
        
        return self.contentImages?() ?? [BundleImageWithName("guide1")!,BundleImageWithName("guide2")!,BundleImageWithName("guide3")!,BundleImageWithName("guide4")!]
    }()
    fileprivate lazy var cc_contentSize : CGSize = {
        return self.contentSize?() ?? self.frame.size
    }()
    fileprivate lazy var cc_titles : Array<String> = {
        return self.titles?() ?? Array()
    }()
    
    fileprivate lazy var cc_doneButton : UIButton = {
        if self.doneButton?() != nil{
            let button : UIButton = (self.doneButton?())!
            if button.frame.origin.equalTo(CGPoint.zero){
                button.frame = CGRect.init(x: self.frame.size.width * 0.1, y: self.frame.size.height * self.cc_doneButtonYLocation, width: self.frame.size.width * 0.8, height: 50)
            }
            button.addTarget(self, action: #selector(onFinishedIntroButtonPressed), for: .touchUpInside)
            return button;
            
        }else{
            let button : UIButton = UIButton(frame:CGRect.init(x: self.frame.size.width * 0.1, y: self.frame.size.height * self.cc_doneButtonYLocation, width: self.frame.size.width * 0.8, height: 33))
            button.setImage(BundleImageWithName("button_start")!, for: UIControlState.normal)
            button.addTarget(self, action:#selector(onFinishedIntroButtonPressed), for: .touchUpInside)
            return button
        }
    }()
    
    fileprivate lazy var cc_doneButtonYLocation : CGFloat = {
        return self.doneButtonYLocation?() ?? 0.9
    }()
    
    fileprivate lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.cc_contentImages.count
        //pc.pageIndicatorTintColor = UIColor.blueColor()
        return pc
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let sv : UIScrollView = UIScrollView(frame:self.frame)
        sv.delegate = self as UIScrollViewDelegate
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    deinit{
        print("GuideView 释放")
    }
}

// MARK: - 私有方法
extension GuideView{
    /**
     检查版本
     
     - returns: return value description
     */
    func checkVersionAndFirstLaunch() ->Bool{
        return isFristLaunch() && compareVersion()
    }
    private func isFristLaunch()->Bool{
        let firstLaunch = UserDefaults.standard.bool(forKey: LocalFirstLaunchKey)
        if !firstLaunch{
            UserDefaults.standard.set(true, forKey: LocalFirstLaunchKey)
            return false
        }
        return true
    }
    
    private func compareVersion() ->Bool{
        if let dic = Bundle.main.infoDictionary{
            if let str : String = dic["CFBundleShortVersionString"] as? String {
                let localStr = UserDefaults.standard.string(forKey: LocalVersionKey)
                if str != localStr{
                    UserDefaults.standard.setValue(str, forKey: LocalVersionKey)
                    return false
                }
                return true
            }
            return true
        }
        
        return true
    }
    
    func setUp(){
        //添加背景图
        if self.cc_backgroundImage != nil{
            let backgroundImageView = UIImageView(frame:self.frame)
            backgroundImageView.image = self.cc_backgroundImage
            self.addSubview(backgroundImageView)
        }
        //添加scrollView
        self.addSubview(self.scrollView)
        
        //添加contentView
        for index in 0 ..< self.cc_contentImages.count{
            let originWidth = self.frame.size.width
            let originHeight = self.frame.size.height
            
            let view = UIView(frame:CGRect.init(x: originWidth * CGFloat(index), y: 0, width: originWidth, height: originHeight))
            
            //内容

            let imageview = UIImageView(frame:CGRect(x: 0, y: 0, width: cc_contentSize.width, height: self.cc_contentSize.height))
                
            let point = CGPoint.init(x: view.frame.size.width - self.frame.width / 2, y: self.frame.height / 2)
            imageview.center = point
            imageview.contentMode = .scaleAspectFill
            imageview.image = self.cc_contentImages[index]
            view.addSubview(imageview)
            
            //标题
            if self.cc_titles.count > 0{
                let titleLabel = UILabel(frame:CGRect.init(x:0, y:self.frame.size.height * 0.05, width:self.frame.size.width * 0.8,height: 40))
                titleLabel.center = CGPoint.init(x: self.center.x, y: self.frame.size.height * 0.1)
                titleLabel.text = self.cc_titles.count > index ? self.cc_titles[index] : nil
                titleLabel.font = UIFont(name: "HelveticaNeue", size: 25.0)
                titleLabel.textColor = UIColor.white
                titleLabel.textAlignment = .center
                titleLabel.numberOfLines = 0
                view.addSubview(titleLabel)
            }
            self.scrollView.addSubview(view)
        }
        
        //添加完成按钮
        self.addSubview(self.cc_doneButton)
        self.pageControl.frame = CGRect.init(x:0, y:self.cc_doneButton.frame.minY - 33, width:self.frame.width, height:20)
        self.addSubview(self.pageControl)
        
        let scrollPoint = CGPoint.init(x: 0, y: 0)
        print(self.scrollView.contentSize)
        self.scrollView.contentSize =  CGSize.init(width: self.frame.size.width * CGFloat(self.cc_contentImages.count), height: self.frame.size.height)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
}
// MARK: - 对外提供的方法
extension GuideView{
    
    public func showGuideView(){
        //检查版本号 和 是否首次启动
        if checkVersionAndFirstLaunch() {
            return
        }
        //显示
        self.setUp()
        w.addSubview(self)
    }
    
}

// MARK: - UIScrollViewDelegate
extension GuideView:UIScrollViewDelegate{
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.bounds.width
        let pageFraction = self.scrollView.contentOffset.x / pageWidth
        self.pageControl.currentPage = Int(pageFraction)
        
    }
}

// MARK: - Button Action
extension GuideView {
    func onFinishedIntroButtonPressed(){
        w.removeFromSuperview()
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.w.alpha = 0
        }) { (B:Bool) -> Void in
            for v in self.w.subviews{
                v.removeFromSuperview()
            }
            self.w.removeFromSuperview()
        }
    }
}
