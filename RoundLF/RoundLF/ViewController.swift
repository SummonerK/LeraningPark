//
//  ViewController.swift
//  RoundLF
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bton_center: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bton_center.layer.addSublayer(drawBaseLayerWith(from: 0, to: 360))
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func drawBaseLayerWith(from:Float, to:Float) -> CAShapeLayer {
        
        var scale_begin:CGFloat?
        var scale_end:CGFloat?
        
        scale_begin = CGFloat(Float.pi*2*from/360)
        scale_end = CGFloat(Float.pi*2*to/360)
        
        let IBPath = UIBezierPath.init(arcCenter: CGPoint.init(x: self.view.center.x, y: self.view.center.y + 20), radius: 20, startAngle: scale_begin!, endAngle: scale_end!, clockwise: true)
        
        let lineLayer = CAShapeLayer.init()
        lineLayer.frame = bton_center.frame
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.path = IBPath.cgPath
        lineLayer.strokeColor = UIColor.lightText.cgColor
        lineLayer.lineWidth = 0.5
        
//        bton_center.layer.addSublayer(lineLayer)
        
        return lineLayer
        
    }


}

