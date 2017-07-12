//
//  user_addressAddVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/20.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

//typealias BadBack = (String) -> Void

import IQKeyboardManagerSwift

import RxSwift
import ObjectMapper
import SwiftyJSON

class user_addressAddVC: UIViewController {
    
//    var BadBack:BadBack?
    
    @IBOutlet weak var tf_name: UITextField!
    
    @IBOutlet weak var tf_phone: UITextField!
    
    @IBOutlet weak var label_addressArea: UILabel!
    
    @IBOutlet weak var tf_addressDetail: UITextField!
    
    @IBOutlet weak var bton_area: UIButton!
    
    @IBOutlet weak var image_default: UIImageView!

    var modelEdit:ModelAddressItem?
    
    var tag_pagefrom:Int? = 1
    
    var isDefault:Int? = 0
    
    // tag_pagefrom = 1 新建
    // tag_pagefrom = 2 编辑
    
    let disposeBag = DisposeBag()
    let VM = ViewModel()
    
    var _tapGesture: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        KeyWindow.removeGestureRecognizer(_tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        self.view.addSubview(addressPickerView)
//        self.view.addSubview(ypbinputAccessoryView)
        
        if tag_pagefrom == 2 {
            tf_name.text = modelEdit?.receiverName
            tf_phone.text = modelEdit?.receiverPhone
            label_addressArea.text = modelEdit?.area
            tf_addressDetail.text = modelEdit?.address
            
            if modelEdit?.isDefault == 0 {
                
                isDefault = 0
                image_default.image = IBImageWithName("choose_n")
            }else{
                isDefault = 1
                image_default.image = IBImageWithName("choose_s")
            }
        }
        
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))

        KeyWindow.addGestureRecognizer(_tapGesture)

    }
    
    /** Resigning on tap gesture.   (Enhancement ID: #14)*/
    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            PrintFM("close")
            closeAddress()
        }
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = tag_pagefrom==2 ? "编辑收货人" : "新建收货人"
    }
    
    func actionBack(_ sender: Any) {
        
//        BadBack!("122")
        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "payNotifation"), object: self,userInfo:["key":"value"])
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func pushData(_ sender: Any) {
        
        PrintFM("\(String(describing: tf_name.text))\n\(String(describing: tf_phone.text))\n\(String(describing: tf_addressDetail.text))\n\(String(describing: label_addressArea.text))")
            
        if let name = tf_name.text,name != "",let phone = tf_phone.text,phone.isFullTelNumber(),let detail = tf_addressDetail.text,detail != "",let area = label_addressArea.text,area != "城市"{
            
            if tag_pagefrom == 2 {
                
                let model_address = ModelAddressUpdatePost()
                model_address.partnerId = PartNerID
                model_address.receiverName = name
                model_address.receiverPhone = phone
                model_address.phone = USERM.Phone
                model_address.area = area
                model_address.address = detail
                model_address.id = modelEdit?.id
                model_address.isDefault = isDefault
                VM.addressUpdate(amodel: model_address)
                    .subscribe(onNext: {(common:ModelCommonBack) in
                        PrintFM("更新设置\(String(describing: common.description))")
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    },onError:{error in
                        if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                            HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                        }else{
                            HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                        }
                        
                    })
                    .addDisposableTo(disposeBag)
                
            }else{
                
                let model_address = ModelAddressAddPost()
                model_address.partnerId = PartNerID
                model_address.receiverName = name
                model_address.receiverPhone = phone
                model_address.phone = USERM.Phone
                model_address.address = detail
                model_address.area = area
                model_address.isDefault = isDefault
                
                VM.addressAdd(amodel: model_address)
                    .subscribe(onNext: { (common:ModelCommonBack) in
                        PrintFM("添加\(String(describing: common.description))")
                        
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
            
        }else{
            HUDShowMsgQuick(msg: "请填写完整信息", toView: KeyWindow, time: 0.8)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addressAction(_ sender: Any) {
        PrintFM("choose Location Address")
        openAddress()
    }
    
    @IBAction func receiveDateChoose(_ sender: Any) {
        
        HUDShowMsgQuick(msg: "此功能暂未开放", toView: KeyWindow, time: 0.8)
    }
    
    @IBAction func defaultAddressChoose(_ sender: Any) {
        if isDefault == 0 {
            isDefault = 1
            image_default.image = IBImageWithName("choose_s")
        }else{
            isDefault = 0
            image_default.image = IBImageWithName("choose_n")
        }
    }
    
    let duration: TimeInterval = 0.5
    
    func openAddress() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: duration) {
            self.addressPickerView.frame = CGRect(x: 0, y: IBScreenHeight - 220, width: IBScreenWidth, height: 220)
            self.view.layoutIfNeeded()
        }
        
    }
    
    func closeAddress() {
        UIView.animate(withDuration: duration) {
            self.addressPickerView.frame = CGRect(x: 0, y: IBScreenHeight, width: IBScreenWidth, height: 220)
            self.view.layoutIfNeeded()
        }
        
    }
    
    lazy var addressPickerView: AddressCityPickerView = {
        let view = AddressCityPickerView(frame: CGRect(x: 0, y: IBScreenHeight+44, width: IBScreenWidth, height: 220))
        view.delegate = self
        return view
    }()
    
    private lazy var ypbinputAccessoryView: YPBInputAccessoryView = {
        let inputAccessoryView = YPBInputAccessoryView(frame: CGRect(x: 0, y: IBScreenHeight, width: IBScreenWidth, height: 44))
        inputAccessoryView.cancleBtn.addTarget(self, action: #selector(didClickEndEditing(_:)), for: UIControlEvents.touchUpInside)
        inputAccessoryView.doneBtn.addTarget(self, action: #selector(didClickEndEditing(_:)), for: UIControlEvents.touchUpInside)
        return inputAccessoryView
    }()
    
    @objc private func didClickEndEditing(_ sender: Any) {
        PrintFM("end Editing")
        closeAddress()
//        addressPickerView.frame = CGRect(x: 0, y: IBScreenHeight+44, width: IBScreenWidth, height: 220)
//        ypbinputAccessoryView.frame = CGRect(x: 0, y: IBScreenHeight, width: IBScreenWidth, height: 44)
    }

}

extension user_addressAddVC: AddressCityPickerViewDelegate {
    
    func addressCityPickerView(view: AddressCityPickerView, cityDidChange province: String, city: String, area: String) {
        
        label_addressArea.text = province + "-" + city + "-" + area
        
    }
    
}

extension user_addressAddVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        closeAddress()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField == tf_phone , let str = textField.text{
            
            let strLength = str.length - range.length  + string.length
            
            if strLength > 11 {
                return false
            }else if strLength==4 || strLength==5{
                
                PrintFM("\(String(describing: str)) is \(str.isTelNumber())")
                
                return str.isTelNumber()
            }
            
        }
        
        return true
        
    }
    
    
}

