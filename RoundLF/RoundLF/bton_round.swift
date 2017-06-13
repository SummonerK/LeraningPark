//
//  bton_round.swift
//  RoundLF
//
//  Created by Luofei on 2017/6/13.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class bton_round: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    override func draw(_ rect: CGRect) {
        self.setLayer()
    }
    
    fileprivate func setLayer() {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint.zero)
        bezier.addLine(to: CGPoint(x: IBScreenWidth * 0.5 - radius, y: 0))
        
        
        let deep = CGFloat(sqrt(40))
        bezier.append(UIBezierPath(arcCenter: CGPoint(x: IBScreenWidth * 0.5, y: deep), radius: radius, startAngle: CGFloat.pi/8, endAngle: CGFloat.pi/6, clockwise: false))
        
        //        bezier.move(to: CGPoint(x: IBScreenWidth * 0.5 + radius, y: 0))
        bezier.addLine(to: CGPoint(x: IBScreenWidth, y: 0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        shapeLayer.shadowColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.9).cgColor
        shapeLayer.shadowOpacity = 0.7
        shapeLayer.shadowRadius = 1.5
        shapeLayer.shadowOffset = CGSize.init(width: 0, height: -2)
        
        
    }

}
