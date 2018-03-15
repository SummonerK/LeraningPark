//
//  LTGPhotoCamear.swift
//  EasyBuy
//
//  Created by Luofei on 2018/3/12.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

let currentResolutionW = CGFloat(720)
let currentResolutionH = CGFloat(1280)

@available(iOS 10.0, *)
class LTGPhotoCamear: UIViewController {
    
    var callbackPicutureData: ((Data?) -> ())?
    
    private var device: AVCaptureDevice?
    private var input: AVCaptureDeviceInput?
    private var imageOutput: AVCapturePhotoOutput?
    
    private var session: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var cropX:Int! = nil
    var cropY:Int! = nil
    
//    fileprivate var showImageContainerView: UIView?
    @IBOutlet weak var showImageView: UIImageView!
    
    @IBOutlet weak var label_msg: UILabel!
    
    fileprivate var picData: Data? = nil{
        didSet{
            
            if let data = picData{
                
                showImageView?.image = UIImage(data: data)
            }
            
        }
    }
    private var flashMode: AVCaptureFlashMode = .auto
    
    @IBOutlet weak var btonGetPic: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setRadiusFor(toview: btonGetPic, radius: 30, lineWidth: 0, lineColor: .clear)
        
        TGPhotoPickerManager.shared.authorizeCamera { (status) in
            if status == .authorized{
                
                self.setDefineValues(cropWidth: IBScreenWidth, cropHeight: IBScreenWidth, screenResolutionW: currentResolutionW, screenResolutionH: currentResolutionH)
                self.setupCamera()
//                self.setupUI()
            }
        }
        
        if #available(iOS 9.0, *) {
            let isVCBased = Bundle.main.infoDictionary?["UIViewControllerBasedStatusBarAppearance"] as? Bool ?? false
            if !isVCBased{
                UIApplication.shared.setStatusBarHidden(false, with: .none)
            }
        }else {
            UIApplication.shared.statusBarStyle = .lightContent
            UIApplication.shared.setStatusBarHidden(false, with: .none)
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func setupCamera() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { success in
            if !success {
                let alertVC = UIAlertController(title: TGPhotoPickerConfig.shared.cameraUsage, message: TGPhotoPickerConfig.shared.cameraUsageTip, preferredStyle: .actionSheet)
                alertVC.addAction(UIAlertAction(title: TGPhotoPickerConfig.shared.confirmTitle, style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        device = cameraWithPosistion(.back)
        input = try? AVCaptureDeviceInput(device: device)
        guard input != nil else {
            return
        }
        
        imageOutput = AVCapturePhotoOutput()
        session = AVCaptureSession()
        session?.beginConfiguration()
        session?.sessionPreset = TGPhotoPickerConfig.shared.sessionPreset
        if session!.canAddInput(input) {
            session!.addInput(input)
        }
        if session!.canAddOutput(imageOutput) {
            session!.addOutput(imageOutput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer?.frame = view.bounds
        previewLayer?.bounds = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth)
        previewLayer?.position = CGPoint(x: IBScreenWidth/2, y: IBScreenHeight/2)
        previewLayer?.videoGravity = TGPhotoPickerConfig.shared.videoGravity
        view.layer.addSublayer(previewLayer!)
        session?.commitConfiguration()
        session?.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func giveupImageAction() {
        showImageView?.image = UIImage()
//        showImageContainerView?.isHidden = true
    }

    @IBAction func useImageAction() {
        
        if picData != nil {
            callbackPicutureData?(picData)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getPicture(_ sender: Any) {
        let connection = imageOutput?.connection(withMediaType: AVMediaTypeVideo)
        guard connection != nil else {
            return
        }
        let photoSettings = AVCapturePhotoSettings()
//        photoSettings.flashMode = flashMode
        let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 720,
                             kCVPixelBufferHeightKey as String: 720,
                             ]
        photoSettings.previewPhotoFormat = previewFormat
        imageOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    private func cameraWithPosistion(_ position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let type = AVCaptureDeviceType(rawValue: TGPhotoPickerConfig.shared.captureDeviceType.rawValue)
        
        return AVCaptureDevice.defaultDevice(withDeviceType: type, mediaType: AVMediaTypeVideo, position: position)
    }
    

}

@available(iOS 10.0, *)
extension LTGPhotoCamear: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            
//            if let sampleBuffer = photoSampleBuffer, let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer){
//                
//                let newImage = CropSubImage(imageData: imageData)
//                
//                picData = UIImageJPEGRepresentation(newImage, 0)
//                if TGPhotoPickerConfig.shared.saveImageToPhotoAlbum{
//                    self.saveImageToPhotoAlbum(newImage)
//                }
//                
//            }
            
            if let sampleBuffer = photoSampleBuffer {
                
                let cropSampleBuffer:CMSampleBuffer?
                
                cropSampleBuffer = self.cropSampleBufferByHardware(buffer: sampleBuffer)
                
                if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: cropSampleBuffer!, previewPhotoSampleBuffer: cropSampleBuffer){
                    
                    picData = imageData
                    
                    let image = UIImage(data: imageData)
                    
                    if TGPhotoPickerConfig.shared.saveImageToPhotoAlbum{
                        self.saveImageToPhotoAlbum(image!)
                    }
                }

            }
                
            else {
                
                picData = nil
            }
        }
    }
    
    fileprivate func saveImageToPhotoAlbum(_ savedImage:UIImage){
        canUseAlbum { (canUse) in
            if canUse{
                
//                let sourceImageRef: CGImage = savedImage.cgImage!
//                
//                let flipImageOrientation = 3
//        
//                //图片反转
//                let normalImage = UIImage.init(cgImage: sourceImageRef, scale: 1, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
                
                UIImageWriteToSavedPhotosAlbum(savedImage, self, #selector(self.imageDidFinishSavingWithErrorContextInfo), nil)
            }
        }
    }
    
    @objc fileprivate func imageDidFinishSavingWithErrorContextInfo(image:UIImage,error:NSError?,contextInfo:UnsafeMutableRawPointer?){
        canUseAlbum { (canUse) in
            if canUse{
                let msg = (error != nil) ? (TGPhotoPickerConfig.shared.saveImageFailTip+"("+(error?.localizedDescription)!+")") : TGPhotoPickerConfig.shared.saveImageSuccessTip
                if !TGPhotoPickerConfig.shared.showCameraSaveSuccess && error == nil{
                    return
                }
                let alert =  UIAlertView(title: TGPhotoPickerConfig.shared.saveImageTip, message: msg, delegate: self, cancelButtonTitle: TGPhotoPickerConfig.shared.confirmTitle)
                alert.show()
            }
        }
    }
    
    
    fileprivate func canUseAlbum(returnClosure:@escaping (Bool)-> ()){
        TGPhotoPickerManager.shared.authorizePhotoLibrary { (status) in
            returnClosure(status == .authorized)
        }
        /*
         if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
         let alertView = UIAlertView(title: TGPhotoPickerConfig.shared.PhotoLibraryUsage, message: TGPhotoPickerConfig.shared.PhotoLibraryUsageTip, delegate: nil, cancelButtonTitle: TGPhotoPickerConfig.shared.confirmTitle, otherButtonTitles: TGPhotoPickerConfig.shared.cancelTitle)
         alertView.tag = TGPhotoPickerConfig.shared.alertViewTag
         alertView.show()
         return false
         }else{
         return true
         }
         */
    }
}

extension LTGPhotoCamear{
    
    func setDefineValues(cropWidth:CGFloat,cropHeight:CGFloat,screenResolutionW:CGFloat,screenResolutionH:CGFloat){
        self.cropX = Int(currentResolutionW/IBScreenWidth*0)
        self.cropY = Int(currentResolutionH/IBScreenHeight*(IBScreenHeight-IBScreenWidth)/2)
    }
    
    func CropSubImage(imageData:Data) -> UIImage {
        
        let cropX = Int(currentResolutionW/IBScreenWidth*0)
        let cropY = Int(currentResolutionH/IBScreenHeight*(IBScreenHeight-IBScreenWidth)/2)
        
        let image = UIImage(data: imageData)
        let subCGImage:CGImage = (image?.cgImage)!
        
        let cropRect = CGRect.init(x: cropX, y: cropY, width: 720, height: 720)
        
        UIGraphicsBeginImageContext(cropRect.size)
        
        let content:CGContext = UIGraphicsGetCurrentContext()!
        
        content.draw(subCGImage, in: cropRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
    
    func cropSampleBufferByHardware(buffer:CMSampleBuffer) -> CMSampleBuffer {
        
        var cropBuffer:CMSampleBuffer? = nil
        
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cropRect = CGRect.init(x: cropX, y: cropY, width: 720, height: 720)
        
        var status:OSStatus?
        
        var pixbuffer:CVPixelBuffer?
        var videoInfo:CMVideoFormatDescription?
        
        if pixbuffer == nil {
            
            let photoSettings = AVCapturePhotoSettings()
            let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first!
            let previewFormat:NSDictionary = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                              kCVPixelBufferWidthKey as String: 720,
                                              kCVPixelBufferHeightKey as String: 720,
                                              ]
            
//            let bufferPtr = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: 1)
            
            status = CVPixelBufferCreate(kCFAllocatorDefault, 720, 720, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, previewFormat, &pixbuffer)
            
            if (status != noErr) {
                print("Crop CVPixelBufferCreate error \(String(describing: status))")
                
                self.label_msg.text = "Crop CMSampleBufferCreateForImageBuffer error \(String(describing: status))"
                
                return cropBuffer!
            }
        }
        
        var ciImage:CIImage = CIImage.init(cvImageBuffer: imageBuffer!)
        ciImage = ciImage.cropping(to: cropRect)
        ciImage = ciImage.applying(__CGAffineTransformMake(0, 0, 0, 0, CGFloat(-cropX), CGFloat(-cropY)))
        
        var ciContext:CIContext! = nil
        
        if ciContext == nil {
            let eaglContent = EAGLContext.init(api: .openGLES3)
            ciContext = CIContext.init(eaglContext: eaglContent!, options: nil)
        }
        
        ciContext.render(ciImage, to: pixbuffer!)
        
        var sampleTime:CMSampleTimingInfo = CMSampleTimingInfo.init(duration: CMSampleBufferGetDuration(buffer), presentationTimeStamp: CMSampleBufferGetPresentationTimeStamp(buffer), decodeTimeStamp: CMSampleBufferGetDecodeTimeStamp(buffer))
        
        if videoInfo == nil {
            
//            let bufferPtr = UnsafeMutablePointer<CMVideoFormatDescription?>.allocate(capacity: 1)
            
            status = CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixbuffer!, &videoInfo)
            
            if status != 0{
                print("Crop CMVideoFormatDescriptionCreateForImageBuffer error \(String(describing: status))")
                
                self.label_msg.text = "Crop CMSampleBufferCreateForImageBuffer error \(String(describing: status))"
                
                return cropBuffer!
            }
            
        }
        
        status = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixbuffer!, true, nil, nil, videoInfo!, &sampleTime, &cropBuffer)
        
        
        if status != 0{
            print("Crop CMSampleBufferCreateForImageBuffer error \(String(describing: status))")
            
            self.label_msg.text = "Crop CMSampleBufferCreateForImageBuffer error \(String(describing: status))"
            
           return cropBuffer!
        }
        
        return cropBuffer!
        
    }
    
    func samplePointer(ptr:UnsafeMutablePointer<CMSampleTimingInfo>){
        print("UnsafeMutablePointer:\(ptr)")
        print("pointee:\(ptr.pointee)")
    }
    
    func sampleBufferPointer(ptr:UnsafeMutablePointer<CMSampleBuffer>){
        print("UnsafeMutablePointer:\(ptr)")
        print("pointee:\(ptr.pointee)")
    }
    
    func reSizeImage(imageData:Data) -> UIImage {
        
        let image = UIImage(data: imageData)
        
        let imageWidth = 720
        let imageHeight = 1280
        
        let inRext:CGRect = CGRect.init(x: 0, y: (imageHeight-imageWidth)/2, width: imageWidth, height: imageWidth)
        
        let sourceImageRef: CGImage = image!.cgImage!
        let newCGImage = sourceImageRef.cropping(to: inRext)!
        
//        let flipImageOrientation = 3
//
//        //图片反转
//        let normalImage = UIImage.init(cgImage: newCGImage, scale: 1, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        
        let normalImage = UIImage.init(cgImage: newCGImage)
        
        return normalImage
    }
    
    func reIBSizeImage(imageData:Data) -> UIImage {
        
        let image = UIImage(data: imageData)
        
        let sourceImageRef:CGImage = (image?.cgImage)!
        
        let imageWidth = 720
        let imageHeight = 1280
        
        let inRext:CGRect = CGRect.init(x: 0, y: (imageHeight-imageWidth)/2, width: imageWidth, height: imageWidth)
        
        //按照给定的矩形区域进行剪裁
        let newImageRef:CGImage = sourceImageRef.cropping(to: inRext)!
        
//        let newImageRef:CGImage = sourceImageRef.cropping(to: inRext)!
//将CGImageRef转换成UIImage
//        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//        let normalImage:UIImage = UIImage.init(cgImage: newImageRef)
        
        let flipImageOrientatin = 3
        
        let flipImage = UIImage(cgImage: newImageRef, scale: 1, orientation: UIImageOrientation(rawValue: flipImageOrientatin)!)
        
        return flipImage
    }
    
    
}

