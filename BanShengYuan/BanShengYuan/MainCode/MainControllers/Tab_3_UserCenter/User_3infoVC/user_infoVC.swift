//
//  user_infoVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import AVFoundation

class user_infoVC: BaseTabHiden,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //network
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    var model_user = ModelUserUpdateInfoPost()
    let model_info = ModelUserGetInfoPost()
    
    @IBOutlet weak var scrollV: UIScrollView!
    
    @IBOutlet weak var imageV_Header: UIImageView!
    
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_sex: UILabel!
    
    @IBOutlet weak var label_bitrhday: UILabel!
    
    @IBOutlet weak var constrain_DatePicker: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker_birthday: UIDatePicker!
    
    var str_path:String?

    var _tapGesture: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        
        KeyWindow.addGestureRecognizer(_tapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        KeyWindow.removeGestureRecognizer(_tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavi()
        
        setRadiusFor(toview: imageV_Header, radius: 30, lineWidth: 1.6, lineColor: FlatWhiteLight)
        
        self.view.backgroundColor = FlatWhiteLight
        setDatePicker()
        
        getInfoData()
        
    }
    
    /** Resigning on tap gesture.   (Enhancement ID: #14)*/
    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            PrintFM("close")
            
            closePicker()
        }
    }
    func setNavi() {
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        
        self.navigationItem.title = "个人信息"
        
        getInfoData()
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //获取个人信息
    
    func getInfoData(){
        
        model_info.partnerId = PARTNERID
        model_info.phone = USERM.Phone
        
        VM.userGetInfo(amodel: model_info)
            .subscribe(onNext: { (posts: ModelUserInfoBack) in
                
                PrintFM("\(posts.description)")
                
                if let memberid = posts.memberId{
                    
                    USERM.setMemberID(uid: memberid)
                   
                }
                
                if let path = posts.avatarUrl{
                    
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/"
                    
                    let filePath: String = String(format: "%@%@", documentPath, path)
                    
                    self.str_path = path
                    
                    if let image:UIImage = UIImage(contentsOfFile: filePath){
                        self.imageV_Header.image = image
                    }
                    
                }
                
                if let sex = posts.sex{
                    if sex == 1{
                        self.label_sex.text = "男"
                    }else if sex == 0 {
                        self.label_sex.text = "女"
                    }else{
                        self.label_sex.text = "未设置"
                    }
                }
                
                if let bir = posts.birthday{
                    
                    self.label_bitrhday.text = bir
                }
                
                if let nick = posts.nickName{
                    
                    self.label_name.text = nick
                }
                
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    
    //MARK: - Action Manager
    ///保存个人资料
    @IBAction func saveAction(_ sender: Any) {

        PrintFM("Action")
        closePicker()
        
        if label_sex.text == "男"{
            model_user.sex = "1"
        }
        if label_sex.text == "女" {
            model_user.sex = "0"
        }
        
        if label_sex.text == "未设置" {
            HUDShowMsgQuick(msg: "请设置性别", toView: self.view, time: 0.8)
            return
        }
        
        model_user.partnerId = PARTNERID
        model_user.phone = USERM.Phone
        
        if let nick = label_name.text,nick != ""{
            model_user.nickName = nick
        }else{
            HUDShowMsgQuick(msg: "昵称不合法", toView: self.view, time: 0.8)
            
            return
        }
        
        if let path = str_path{
            model_user.avatarUrl = path
        }
        
        model_user.birthday = label_bitrhday.text
        
        VM.userUpdate(amodel: model_user)
            .subscribe(onNext: { (common:ModelCommonBack) in
                
                HUDShowMsgQuick(msg: common.msg!, toView: KeyWindow, time: 0.8)
                
                self.navigationController?.popViewController(animated: true)
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)

    }
    ///编辑头像
    @IBAction func HeaderAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        chooseHeadImage()
    }
    ///编辑昵称
    @IBAction func nicNameAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        
        let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "info_NameVC") as! info_NameVC
        Vc.nickNameBack = backNickName(name:)
        Vc.nickName = label_name.text
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    ///编辑性别
    @IBAction func sexAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        
        let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "info_SexVC") as! info_SexVC
        
        if label_sex.text == "男"{
            Vc.sexChoose = "1"
        }
        if label_sex.text == "女" {
            Vc.sexChoose = "2"
        }
        
        Vc.sexBack = backSex(sex:)
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
    func backNickName(name:String) -> Void {
        PrintFM("\(name)")
        label_name.text = name
    }
    
    func backSex(sex:String) -> Void {
        PrintFM("\(sex)")
        
        if sex == "1"{
            label_sex.text = "男"
        }
        if sex == "2" {
            label_sex.text = "女"
        }
    }
    
    ///编辑出生日期
    @IBAction func birthdayAction(_ sender: Any) {
        
        PrintFM("Action")
        
        showPicker()
        
    }
    
    //MARK:- ExtendFunc
    
    //MARK:- 设置头像
    func chooseHeadImage(){
        
        PrintFM("ChooseImage")
        let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        //当选择的类型是图片
        if type == "public.image"
        {
            
            //修正图片的位置
            
//            let image = picker.isEditing ? self.fixOrientation((info[UIImagePickerControllerEditedImage] as! UIImage)) : self.fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
            
            
            let image = self.fixOrientation((info[UIImagePickerControllerEditedImage] as! UIImage))
//            let image = self.fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
            //先把图片转成NSData
            let data = UIImageJPEGRepresentation(image, 0.5)
            
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }catch let error {
                
            }
            
            fileManager.createFile(atPath: documentPath + "image.png", contents: data, attributes: nil)
            //得到选择后沙盒中图片的完整路径
            let filePath: String = String(format: "%@%@", documentPath, "image.png")
            print("filePath:" + filePath)
            
            self.str_path = "image.png"
            
            imageV_Header.image = UIImage(contentsOfFile: filePath)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func fixOrientation(_ aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        
        
        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
        default:
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    
    ///MARK:- 设置日期选择器
    let duration: TimeInterval = 0.5
    func showPicker(){
        UIView.animate(withDuration: duration) {
            self.constrain_DatePicker.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    func closePicker(){
        UIView.animate(withDuration: duration) {
            self.constrain_DatePicker.constant = -200
            self.view.layoutIfNeeded()
        }
    }
    
    func setDatePicker() {
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "YYYY-MM-dd"
        let minDate = dformatter.date(from: "1900-01-01")
        let defaultDate = dformatter.date(from: "1995-01-01")
        
        datePicker_birthday.minimumDate = minDate
        datePicker_birthday.maximumDate = NSDate() as Date
        datePicker_birthday.setDate(defaultDate!, animated: false)
        
        datePicker_birthday.datePickerMode = UIDatePickerMode.date
        
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker_birthday.locale = Locale(identifier: "zh_CN")
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker_birthday.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        
        label_bitrhday.text = datePicker.date.string_from(formatter: "yyyy-MM-dd")
        
        
    }
    
    
    
    
   

}
