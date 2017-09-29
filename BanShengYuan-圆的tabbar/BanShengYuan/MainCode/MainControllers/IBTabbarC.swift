//
//  IBTabbarC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class IBTabbarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayer()
        dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setLayer() {
        let bezier = UIBezierPath()
//        bezier.move(to: CGPoint.zero)
//        bezier.addLine(to: CGPoint(x: IBScreenWidth * 0.5 - radius, y: 0))
        
        let deep = CGFloat(23-sqrt(40))
        bezier.append(UIBezierPath(arcCenter: CGPoint(x: IBScreenWidth * 0.5, y: deep), radius: radius, startAngle:CGFloat.pi*15/8, endAngle: CGFloat.pi*9/8, clockwise: false))
        
//        bezier.move(to: CGPoint(x: IBScreenWidth * 0.5 + radius, y: 0))
//        bezier.addLine(to: CGPoint(x: IBScreenWidth, y: 0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        shapeLayer.shadowColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.9).cgColor
        shapeLayer.shadowOpacity = 0.7
        shapeLayer.shadowRadius = 1.5
//        shapeLayer.shadowOffset = CGSize.init(width: 0, height: -3)
        
        tabBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        tabBar.layer.insertSublayer(shapeLayer, at: 0)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
  
    }
    
    func configTabBar() {
        let item = self.tabBar.items?[1] as!UITabBarItem
        item.title = "精彩活动"
        
    }
    
    func dropShadow(){
        let path = CGMutablePath.init()
        path.addRect(self.tabBar.bounds)
        self.tabBar.layer.shadowPath = path
        path.closeSubpath()
        
        setshadowFor(aview: self.tabBar, OffSet: CGSize.init(width: 1, height: -3))

    }
    
}

