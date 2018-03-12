//
//  CameraSessionController.swift
//  iOSSwiftSimpleAVCamera
//
//  Created by Bradley Griffith on 7/1/14.
//  Copyright (c) 2014 Bradley Griffith. All rights reserved.
//


import UIKit
import AVFoundation
import CoreMedia
import CoreImage

@objc protocol CameraSessionControllerDelegate {
	@objc optional func cameraSessionDidOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!)
}

typealias CameraBack = (_ image: UIImage?, _ error: NSError?) -> Void

class CameraSessionController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	var session: AVCaptureSession!
	var sessionQueue: DispatchQueue!
	var videoDeviceInput: AVCaptureDeviceInput!
	var videoDeviceOutput: AVCaptureVideoDataOutput!
	var stillImageOutput: AVCapturePhotoOutput!
	var runtimeErrorHandlingObserver: AnyObject?
	
	var sessionDelegate: CameraSessionControllerDelegate?
    
    var cameraItem:CameraBack!
	
	
	/* Class Methods
	------------------------------------------*/
	
	class func deviceWithMediaType(_ mediaType: String, position: AVCaptureDevicePosition) -> AVCaptureDevice {

		let devices = AVCaptureDevice.devices(withMediaType: mediaType)
//        var captureDevice: AVCaptureDevice = devices.firstObject as! AVCaptureDevice
		var captureDevice: AVCaptureDevice! = nil
		for object:Any in devices! {
			let device = object as! AVCaptureDevice
			if (device.position == position) {
				captureDevice = device
				break
			}
		}

		return captureDevice
	}
	
	
	/* Lifecycle
	------------------------------------------*/
	
	override init() {
		super.init();
		
		self.session = AVCaptureSession()
		
		self.authorizeCamera();
		
		self.sessionQueue = DispatchQueue(label: "CameraSessionController Session", attributes: [])
        
        if isCameraAvailable() {
            print("前置摄像头可用。。")
        }else{
            print("前置摄像头不可用。。")
            
            DispatchQueue.main.async(execute: {
                UIAlertView(
                    title: "Could not use camera!",
                    message: "前置摄像头不可用。。",
                    delegate: self,
                    cancelButtonTitle: "OK").show()
            })
            return
        }
		
		self.sessionQueue.async(execute: {
			self.session.beginConfiguration()
			self.addVideoInput()
			self.addVideoOutput()
			self.addStillImageOutput()
			self.session.commitConfiguration()
			})
	}
	
	
	/* Instance Methods
	------------------------------------------*/
	
	func authorizeCamera() {
		AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
			(granted: Bool) -> Void in
			// If permission hasn't been granted, notify the user.
			if !granted {
				DispatchQueue.main.async(execute: {
					UIAlertView(
						title: "Could not use camera!",
						message: "This application does not have permission to use camera. Please update your privacy settings.",
						delegate: self,
						cancelButtonTitle: "OK").show()
					})
			}
			});
	}
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }
	
	func addVideoInput() -> Bool {
		var success: Bool = false
		var error: NSError?
		
		let videoDevice: AVCaptureDevice? = CameraSessionController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.back)
        
        if videoDevice != nil{
            print("拍摄设备 正常")
        }else{
            
            print("未检测到拍摄设备")
            success = false
        }
        
//		self.videoDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: error) as AVCaptureDeviceInput;
        
        do{
            try self.videoDeviceInput = AVCaptureDeviceInput.init(device: videoDevice)
        }catch let aerror as NSError{
            print(aerror)
            error = aerror
        }
        
        
		if !(error != nil) {
			if self.session.canAddInput(self.videoDeviceInput) {
				self.session.addInput(self.videoDeviceInput)
				success = true
			}
		}
		
		return success
	}
	
	func addVideoOutput() {
		var rgbOutputSettings: NSDictionary = NSDictionary(object: Int(CInt(kCIFormatRGBA8)), forKey: kCVPixelBufferPixelFormatTypeKey as! NSCopying)
		
		self.videoDeviceOutput = AVCaptureVideoDataOutput()
		
		self.videoDeviceOutput.alwaysDiscardsLateVideoFrames = true
		
		self.videoDeviceOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
		
		if self.session.canAddOutput(self.videoDeviceOutput) {
			self.session.addOutput(self.videoDeviceOutput)
		}
	}
	
	func addStillImageOutput() {
		self.stillImageOutput = AVCapturePhotoOutput()
        
//		self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//        let settings = AVCapturePhotoSettings()
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                             kCVPixelBufferWidthKey as String: 300,
//                             kCVPixelBufferHeightKey as String: 300,
//                             ]
//        settings.previewPhotoFormat = previewFormat
//        
//        self.stillImageOutput.capturePhoto(with: settings, delegate: self)
		
		if self.session.canAddOutput(self.stillImageOutput) {
			self.session.addOutput(self.stillImageOutput)
		}
	}
	
	func startCamera() {
		self.sessionQueue.async(execute: {
			let weakSelf: CameraSessionController? = self
			self.runtimeErrorHandlingObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureSessionRuntimeError, object: self.sessionQueue, queue: nil, using: {
				(note: Notification!) -> Void in
				
				let strongSelf: CameraSessionController = weakSelf!
				
				strongSelf.sessionQueue.async(execute: {
					strongSelf.session.startRunning()
				})
			})
			self.session.startRunning()
		})
	}
	
	func teardownCamera() {
		self.sessionQueue.async(execute: {
			self.session.stopRunning()
			NotificationCenter.default.removeObserver(self.runtimeErrorHandlingObserver)
		})
	}
	
	func focusAndExposeAtPoint(_ point: CGPoint) {
		self.sessionQueue.async(execute: {
			let device: AVCaptureDevice = self.videoDeviceInput.device
            
            do{
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureFocusMode.autoFocus) {
                    device.focusPointOfInterest = point
                    device.focusMode = AVCaptureFocusMode.autoFocus
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.autoExpose) {
                    device.exposurePointOfInterest = point
                    device.exposureMode = AVCaptureExposureMode.autoExpose
                }
                
                device.unlockForConfiguration()
            }catch let error as NSError{
                print(error)
            }
            
		})
	}
	
	func captureImage(_ completion:((_ image: UIImage?, _ error: NSError?) -> Void)?) {
		if !(completion != nil) || !(self.stillImageOutput != nil) {
			return
		}
		
        cameraItem = completion
        
	}
	
	
	/* AVCaptureVideoDataOutput Delegate
	------------------------------------------*/
	
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
		self.sessionDelegate?.cameraSessionDidOutputSampleBuffer?(sampleBuffer)
	}
	
}

extension CameraSessionController:AVCapturePhotoCaptureDelegate{
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            
            cameraItem(nil,error as NSError)
        }else{
            
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
                cameraItem(UIImage(data: dataImage),nil)
                
            }else {
                cameraItem(nil,NSError())
            }
            
        }
        
    }
    

}
