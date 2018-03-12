//
//  CamearVC.swift
//  EasyBuy
//
//  Created by Luofei on 2018/3/9.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width

//MARK:-设置圆角
func setRadiusFor(toview:UIView,radius:CGFloat,lineWidth:CGFloat,lineColor:UIColor){
    toview.layer.cornerRadius = radius
    toview.layer.borderColor = lineColor.cgColor
    toview.layer.borderWidth = lineWidth
    toview.layer.masksToBounds = true
}

class CamearVC: UIViewController,CameraSessionControllerDelegate {
    
    @IBOutlet weak var btonGetPic: UIButton!
    @IBOutlet weak var imageVSumb: UIImageView!
    
    var cameraSessionController: CameraSessionController!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRadiusFor(toview: btonGetPic, radius: 30, lineWidth: 0, lineColor: .clear)

        self.cameraSessionController = CameraSessionController()
        self.cameraSessionController.sessionDelegate = self
        self.setupPreviewLayer()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cameraSessionController.startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraSessionController.teardownCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Instance Methods
     ------------------------------------------*/
    
    func setupPreviewLayer() {
        let minSize: CGFloat = CGFloat(min(IBScreenWidth, IBScreenHeight))
        
        let bounds: CGRect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: minSize, height: minSize)
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.cameraSessionController.session)
        self.previewLayer.bounds = bounds
        self.previewLayer.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    
    @IBAction func goToCamera(_ sender: Any) {
        
        self.cameraSessionController.captureImage(pictureBack(_:_:))
        
    }
    
    func pictureBack(_ image: UIImage?, _ error: NSError?) -> Void {
        
        if image != nil {
            
            imageVSumb.image = image
            
        }else{
            print(error ?? "拍照失败")
        }
    }
    

}
