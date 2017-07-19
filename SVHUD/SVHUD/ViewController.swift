//
//  ViewController.swift
//  SVHUD
//
//  Created by Luofei on 2017/7/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImageIO

let HUDGIFData = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "demo", ofType: "gif")!))

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showHudAction(_ sender: Any) {
        showhud()
    }

}

func showhud() {
    
    let gifimage = UIImageView()
    gifimage.image = UIImage.gifImage(data: HUDGIFData as NSData)
    
    let image = UIImage.gifImage(data: HUDGIFData as NSData)
    
//    SVProgressHUD.setContainerView(gifimage)
    
//    SVProgressHUD.show()
    
//    SVProgressHUD.show(image, status: "")
    
//    SVProgressHUD.show(image, status: nil)
    
    SVProgressHUD.setViewForExtension(gifimage)
    
    SVProgressHUD.setMinimumSize(CGSize.init(width: 100, height: 100))
    
    SVProgressHUD.dismiss(withDelay: 1)
    
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
