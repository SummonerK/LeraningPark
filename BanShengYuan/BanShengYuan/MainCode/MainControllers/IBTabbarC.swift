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

//        let item = self.tabBar.items?[1] as! UITabBarItem
        
        setLayer()
//        self.dropShadowWithOffSet(offset: CGSize.init(width: 0, height: -0.5), radius: 1, color: UIColor.lightGray, opacity: 0.5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
    fileprivate func setLayer() {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint.zero)
        bezier.addLine(to: CGPoint(x: IBScreenWidth * 0.5 - 27, y: 0))
        
        bezier.append(UIBezierPath(arcCenter: CGPoint(x: IBScreenWidth * 0.5, y: 15), radius: 30, startAngle: 0, endAngle: CGFloat.pi *  1, clockwise: false))
        
        bezier.move(to: CGPoint(x: IBScreenWidth * 0.5 + 27, y: 0))
        bezier.addLine(to: CGPoint(x: IBScreenWidth, y: 0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        tabBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        tabBar.layer.insertSublayer(shapeLayer, at: 0)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
    
    /*// Creating shadow path for better performance
     CGMutablePathRef path = CGPathCreateMutable();
     CGPathAddRect(path, NULL, self.tabBar.bounds);
     self.tabBar.layer.shadowPath = path;
     CGPathCloseSubpath(path);
     CGPathRelease(path);
     
     self.tabBar.layer.shadowColor = color.CGColor;
     self.tabBar.layer.shadowOffset = offset;
     self.tabBar.layer.shadowRadius = radius;
     self.tabBar.layer.shadowOpacity = opacity;
     
     // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
     self.tabBar.clipsToBounds = NO;  */
    
//    func dropShadowWithOffSet(offset:CGSize , radius:CGFloat ,color:UIColor,opacity:CGFloat){
//        let path = CGMutablePath.init()
//        path.addRect(self.tabBar.bounds)
//        self.tabBar.layer.shadowPath = path
//        path.closeSubpath()
//        
//        self.tabBar.layer.shadowColor = color.cgColor
//        self.tabBar.layer.shadowOffset = offset
//        self.tabBar.layer.shadowRadius = radius
//        self.tabBar.layer.shadowOpacity = Float(opacity)
//        
//        
//    }

}

