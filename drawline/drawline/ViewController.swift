//
//  ViewController.swift
//  drawline
//
//  Created by Luofei on 2017/6/22.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var view_line: UIView!
    
    
    let PTX = 136
    let PTY = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: 44, height: 44)
//        shapeLayer.contentsCenter = view_line.center
//        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: PTX, y: PTY-22))
        path.addLine(to: CGPoint.init(x: PTX-22, y: PTY))
        
        shapeLayer.path = path
        
        view_line.layer.addSublayer(shapeLayer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

