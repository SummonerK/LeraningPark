//
//  ViewController.swift
//  EasyBuy
//
//  Created by Luofei on 2018/3/9.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var handlePhotosBlock: HandlePhotosBlock?
    var handlePhotoModelsBlock: HandlePhotoModelsBlock?
    
    @IBOutlet weak var imageVSumb: UIImageView!
    @IBOutlet weak var imageVResult: UIImageView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let cropX = Int(currentResolutionW/IBScreenWidth*0)
        let cropY = Int(currentResolutionH/IBScreenHeight*(IBScreenHeight-IBScreenWidth)/2)
        
        print("\(cropX),,,\(cropY)")
        
        let image = UIImage.init(named: "WechatIMG47.jpeg")
        
//        let sourceImageRef: CGImage = image!.cgImage!
//        let newCGImage = sourceImageRef.cropping(to: CGRect.init(x: 0, y: 0, width: 750, height: 750))!
//        
//        let flipImageOrientation = 4
//        
//        //图片反转
//        let normalImage = UIImage.init(cgImage: newCGImage, scale: 1, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        
        imageVSumb.image = image
        
        let normalImage = CropSubImage(image: image!)
        
        imageVResult.image = normalImage
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func goToCamera(_ sender: Any) {
        
        
        if isCameraAvailable() {
            print("前置摄像头可用。。")
        }else{
            print("前置摄像头不可用。。")
            
            DispatchQueue.main.async(execute: {
                UIAlertView(
                    title: "Could not use camera!",
                    message: "前置摄像头不可用",
                    delegate: self,
                    cancelButtonTitle: "OK").show()
            })
            return
        }
        
        
        TGPhotoPickerConfig.shared.saveImageToPhotoAlbum = true
        
        let cameraVC = LTGPhotoCamear(nibName: "LTGPhotoCamear", bundle: nil)
        
        cameraVC.callbackPicutureData = { imgData in
            let bigImg = UIImage(data:imgData!)
            let imgData = UIImageJPEGRepresentation(bigImg!,TGPhotoPickerConfig.shared.compressionQuality)
            let smallImg = bigImg
            let model = TGPhotoM()
            model.bigImage = bigImg
            model.imageData = imgData
            model.smallImage = smallImg
            
            self.imageVSumb.image = bigImg
            
            self.handlePhotoModelsBlock?([model])
            self.handlePhotosBlock?([nil],[smallImg],[bigImg],[imgData])
        }
        
        UIApplication.shared.keyWindow?.currentVC()?.present(cameraVC, animated: true, completion: nil)

    }
    
    @IBAction func goToCamera1(_ sender: Any) {
        
        if isCameraAvailable() {
            print("前置摄像头可用。。")
        }else{
            print("前置摄像头不可用。。")
            
            DispatchQueue.main.async(execute: {
                UIAlertView(
                    title: "Could not use camera!",
                    message: "前置摄像头不可用",
                    delegate: self,
                    cancelButtonTitle: "OK").show()
            })
            return
        }
        
        let cameraVC = TGCameraVC()
        
        cameraVC.callbackPicutureData = { imgData in
            let bigImg = UIImage(data:imgData!)
            let imgData = UIImageJPEGRepresentation(bigImg!,TGPhotoPickerConfig.shared.compressionQuality)
            let smallImg = bigImg
            let model = TGPhotoM()
            model.bigImage = bigImg
            model.imageData = imgData
            model.smallImage = smallImg
            
            self.imageVSumb.image = bigImg
            
            self.handlePhotoModelsBlock?([model])
            self.handlePhotosBlock?([nil],[smallImg],[bigImg],[imgData])
        }
        
        UIApplication.shared.keyWindow?.currentVC()?.present(cameraVC, animated: true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CropSubImage(image:UIImage) -> UIImage {
        
        print("\(image.size.width)------\(image.size.height)")
        
        let cropX = Int(currentResolutionW/IBScreenWidth*0)
        let cropY = Int(currentResolutionH/IBScreenHeight*(IBScreenHeight-IBScreenWidth)/2)
        
        let cropRect = CGRect.init(x: cropX, y: cropY, width: 720, height: 720)
        
        let subCGImage:CGImage = (image.cgImage)!.cropping(to: cropRect)!
        
        UIGraphicsBeginImageContext(cropRect.size)
        
        let content:CGContext = UIGraphicsGetCurrentContext()!
        
        content.draw(subCGImage, in: CGRect.init(x: 0, y: 0, width: 720, height: 720))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let flipImage = UIImage.init(cgImage: newImage!.cgImage!, scale: image.scale, orientation: UIImageOrientation.downMirrored)
        
        return flipImage
    }


}

