//
//  ImageVSetting.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/19.
//  Copyright © 2018年 FreeMud. All rights reserved.
//


import UIKit
import Foundation
import Kingfisher

///根据颜色获取图片
func createImageWithColor(color: UIColor) -> UIImage
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

extension UIImageView{

    func IBImageSys(_ imageName:String){
        
        self.image = UIImage.init(named: imageName)
    }

    func IBWSetImage(withPath:String) {
        
        let combinPath = ImageUrlPath + withPath
        
        self.kf.setImage(with: URL(string: combinPath), placeholder: createImageWithColor(color: FlatLightWhiteF1), options: nil, progressBlock: nil, completionHandler: nil)
    }

    func IBSetImage(withPath:String) {
        
        print("combinPath = \(withPath)")
        
        self.kf.setImage(with: URL(string: withPath), placeholder: createImageWithColor(color: FlatLightWhiteF1), options: nil, progressBlock: nil, completionHandler: nil)
    }

}
