//
//  AddingTool.swift
//  GoodAdding
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

public let size_goodslayer = 20.0

typealias animationFinishedBlock = (_ finish : Bool) -> Void

class AddingTool: NSObject,CAAnimationDelegate {
    
    private var layer : CALayer?
    var aniFinishedBlock : animationFinishedBlock?
    override init() {
        super.init()
    }
    //MARK: - 开始走的方法
    func startAnimation(view : UIView,andRect rect : CGRect,andFinishedRect finishPoint : CGPoint, andFinishBlock completion : @escaping animationFinishedBlock) -> Void{
        
        layer = CALayer()
        layer?.backgroundColor = UIColor.blue.cgColor
        layer?.contentsGravity = kCAGravityResize
        layer?.frame = rect
        layer?.cornerRadius = CGFloat(size_goodslayer/2)
        
        let myWindow : UIView = ((UIApplication.shared.delegate?.window)!)!
        myWindow.layer.addSublayer(layer!)
        //创建路径 其路径是抛物线
        let path : UIBezierPath = UIBezierPath()
        path.move(to: (layer?.position)!)
        path.addQuadCurve(to: finishPoint, controlPoint:CGPoint(x: myWindow.frame.size.width/2, y: rect.origin.y - 40))

        //创建 关键帧动画 负责曲线的运动
        let pathAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")//位置的平移
        pathAnimation.path = path.cgPath

        let groups : CAAnimationGroup = CAAnimationGroup()
        groups.animations = [pathAnimation]
        groups.duration = 1.5// S
        groups.fillMode = kCAFillModeForwards
        groups.isRemovedOnCompletion = false
        groups.delegate = self
        self.layer?.add(groups, forKey: "groups")
        aniFinishedBlock = completion
    }
    
    //MARK: - 上下浮动
    func shakeAnimation(shakeView : UIView){
        let basicAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        basicAnimation.duration = 0.25
        basicAnimation.fromValue = NSNumber(value: -5)
        basicAnimation.toValue = NSNumber(value: 5)
        basicAnimation.autoreverses = true
        shakeView.layer.add(basicAnimation, forKey: "shake")
    }
    //MARK: -CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == layer!.animation(forKey: "groups"){
            layer?.removeFromSuperlayer()
            layer = nil
            if (aniFinishedBlock != nil) {
                aniFinishedBlock!(true)
            }
        }
    }

}

extension UIImage {
    class func createImageWithColor(color: UIColor) -> UIImage
    {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
}

