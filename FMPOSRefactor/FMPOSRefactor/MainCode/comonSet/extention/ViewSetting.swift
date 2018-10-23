//
//  viewAnimation.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/17.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation

//抖动方向枚举
public enum IBLShakeDirection: Int {
    case horizontal  //水平抖动
    case vertical  //垂直抖动
}

extension UIView{
    
    // MARK: - ViewAnimation
    
    /// View抖动
    func IBLViewShakeShake(_ direction:IBLShakeDirection) {
        let animation:CAKeyframeAnimation!
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-8, 8, -7, 6, -4, 3, 0.0]
        self.layer.add(animation, forKey: "shake")
    }
    
    func IBLViewWaveShake(){
        let animation:CAKeyframeAnimation!
        animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [1.04,1.08, 1.11, 1.08, 1.04, 1, 0.96, 1]
        self.layer.add(animation, forKey: "waveshake")
    }
    
    /**
     UIView.animate(withDuration: 0.2, animations: {
     cell.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
     }, completion: { (_) in
     if !isValue!{
     cell.IBLViewShakeShake(.horizontal)
     }
     UIView.animate(withDuration: 0.5, animations: {
     cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
     }, completion: { (_) in
     cell.backgroundColor = IBLColorWhite
     })
     })s
     
     */

    
    /// view 设置背景图片 铺开
    func setViewBackgroudImage(image: UIImage) {
        self.layoutIfNeeded()
        UIGraphicsBeginImageContext(self.frame.size)
        image.draw(in: self.bounds)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: img)
    }
    
    //  MARK: - ViewSetting
    
    /// 部分圆角
    ///
    /// .IBLCorner(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 12)
    /// .IBLCorner(byRoundingCorners: .allCorners, radii: 12)
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func IBLCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
//        print("\(self.bounds)")
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    // MARK: - ViewAction
    
    /// view 添加点击事件
    func addClickListener(target: Any,action: Selector) {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}
