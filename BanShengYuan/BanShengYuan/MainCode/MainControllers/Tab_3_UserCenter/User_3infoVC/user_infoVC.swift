//
//  user_infoVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class user_infoVC: BaseTabHiden{

    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_sex: UILabel!
    
    @IBOutlet weak var label_bitrhday: UILabel!
    
    @IBOutlet weak var constrain_DatePicker: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker_birthday: UIDatePicker!
    
    var model_user = ModelUserInfo()
    
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
        
        self.view.backgroundColor = FlatWhiteLight
        setDatePicker()
        
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        
        KeyWindow.addGestureRecognizer(_tapGesture)
        
    }
    
    /** Resigning on tap gesture.   (Enhancement ID: #14)*/
    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            PrintFM("close")
            
            closePicker()
        }
    }
    func setNavi() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "个人信息"
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action Manager
    ///保存个人资料
    @IBAction func saveAction(_ sender: Any) {

        PrintFM("Action")
        closePicker()

    }
    ///编辑头像
    @IBAction func HeaderAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        
    }
    ///编辑昵称
    @IBAction func nicNameAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        
    }
    ///编辑性别
    @IBAction func sexAction(_ sender: Any) {
        
        PrintFM("Action")
        closePicker()
        
    }
    ///编辑出生日期
    @IBAction func birthdayAction(_ sender: Any) {
        
        PrintFM("Action")
        
        showPicker()
        
    }
    
    
    ///MARK:- 设置日期选择器
    let duration: TimeInterval = 0.5
    func showPicker(){
        UIView.animate(withDuration: duration) {
//            self.scrollV.zoomScale = 0.9
            self.constrain_DatePicker.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    func closePicker(){
        UIView.animate(withDuration: duration) {
//            self.scrollV.zoomScale = 1
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
