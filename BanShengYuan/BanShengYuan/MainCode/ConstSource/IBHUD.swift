//
//  IBHUD.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/16.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import ImageIO
import Kingfisher
// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

// LastWindow
let LastWindow : UIWindow = UIApplication.shared.windows.last!

let HUDGIFData = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "demo", ofType: "gif")!))

private var HUDKey = "HUDKey"

func HUDGifCustomShow(){
    
    let hud = MBProgressHUD.showAdded(to: KeyWindow, animated: true)
    hud.backgroundView.color = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 0.6)
    hud.mode = MBProgressHUDMode.customView

    let gifimage = UIImageView()
    gifimage.image = UIImage.gifImage(data: HUDGIFData as NSData)
    hud.customView = gifimage
    
    hud.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    hud.bezelView.style = .solidColor
    hud.animationType = MBProgressHUDAnimation.zoomIn
    
    //延迟隐藏
    hud.hide(animated: true, afterDelay:1.2)
}

extension UIImage {
    static func gifImageArray(data: NSData) -> [UIImage] {
        let source = CGImageSourceCreateWithData(data, nil)!
        let count = CGImageSourceGetCount(source)
        if count <= 1 {
            return [UIImage(data: data as Data)!]
        } else {
            var images = [UIImage]();   images.reserveCapacity(count)
            for i in 0..<count {
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)!
                images.append(UIImage(cgImage: image) )
            }
            return images;
        }
    }
    
    static func gifImage(data: NSData) -> UIImage? {
        let gif = gifImageArray(data: data)
        if gif.count <= 1 {
            return gif[0]
        } else {
            return UIImage.animatedImage(with: gif, duration: TimeInterval(gif.count) * 0.1)
        }
    }
    
}
