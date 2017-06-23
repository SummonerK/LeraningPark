//
//  AddressCityPickerView.swift
//  wholesale
//
//  Created by 袁利伟 on 17/4/25.
//  Copyright © 2017年 ylifegroup. All rights reserved.
//

import UIKit

@objc
protocol AddressCityPickerViewDelegate {
    func addressCityPickerView(view: AddressCityPickerView,cityDidChange province: String,city: String,area: String)
}


class AddressCityPickerView: UIView {
    typealias LocationDescribe = (province: String?,city: String?,area: String?)
    
    weak var delegate: AddressCityPickerViewDelegate?
    
    var locationDescribe: LocationDescribe? {
        didSet{
            guard let locationDescribe = locationDescribe else { return  }
            setInitalLocation(locationDescribe: locationDescribe)
        }
    
    }
    
    
    fileprivate lazy var provinceModelArray: [ProvinceModel] = ProvinceModel.loadCityCodModel()
    fileprivate var currentProvinceModel: ProvinceModel?
    fileprivate var currentCityModel: CityModel?
    fileprivate var currentAreaModel: AreaModel?

    
    
    private lazy var pickerView:UIPickerView = UIPickerView()
    
    init(frame: CGRect,locationDescribe: LocationDescribe? = nil) {
        super.init(frame: frame)
        setUI()
        setData(locationDescribe: locationDescribe)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.white
//        pickerView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.snp.top)
//            make.left.right.bottom.equalTo(self)
//        }
        pickerView.frame = self.bounds
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        
        
    }
    
    
    private func setData(locationDescribe: LocationDescribe? = nil) {
        guard let locationDescribe = locationDescribe else {
            currentProvinceModel = provinceModelArray.first
            currentCityModel = currentProvinceModel?.citylist?.first
            currentAreaModel = currentCityModel?.arealist?.first
            return
        }
        self.locationDescribe = locationDescribe
        
    }
    
    
    private func setInitalLocation(locationDescribe: LocationDescribe) {
        for (provinceIndex,provinceModel) in provinceModelArray.enumerated() {
            
            if provinceModel.provinceName == locationDescribe.province {
                currentProvinceModel = provinceModel
                pickerView.selectRow(provinceIndex, inComponent: 0, animated: false)
                
                for (cityIndex,cityModel) in (provinceModel.citylist?.enumerated())! {
                    if cityModel.cityName == locationDescribe.city {
                        currentCityModel = cityModel
                        pickerView.selectRow(cityIndex, inComponent: 1, animated: false)
                        for (areaIndex,areaModel) in (cityModel.arealist?.enumerated())! {
                            if areaModel.areaName == locationDescribe.area {
                                currentAreaModel = areaModel
                                pickerView.selectRow(areaIndex, inComponent: 2, animated: false)
                            }
                        }

                    }
                }  
            }
        }

        
        
        
    }
    
    
    
    

}


extension AddressCityPickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return provinceModelArray.count
        }else if component == 1 {
            guard let currentProvinceModel = currentProvinceModel else { return 0 }
            return currentProvinceModel.citylist?.count ?? 0
        }else {
            return currentCityModel?.arealist?.count ?? 0
        }
    
    }
    

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if component == 0 {
            let provincemodel = self.provinceModelArray[row]
            return provincemodel.provinceName?.toAttrString(font: UIFont.systemFont(ofSize: 12), color: UIColor.black)
            
        }else if component == 1 {
            guard let currentProvince = currentProvinceModel else { return nil }
            let cityModel = currentProvince.citylist?[row]
            return cityModel?.cityName?.toAttrString(font: UIFont.systemFont(ofSize: 12), color: UIColor.black)
        
        }else {
            
            guard let cityModel = currentCityModel else { return nil }
            
            guard let area = cityModel.arealist?[row] else { return nil }
            
            return area.areaName?.toAttrString(font: UIFont.systemFont(ofSize: 12), color: UIColor.black)
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            currentProvinceModel = provinceModelArray[row]
            currentCityModel = currentProvinceModel?.citylist?.first
            currentAreaModel = currentCityModel?.arealist?.first
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if component == 1 {
            currentCityModel = currentProvinceModel?.citylist?[row]
            currentAreaModel = currentCityModel?.arealist?.first
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else {
            currentAreaModel = currentCityModel?.arealist?[row]
        }
        
        delegate?.addressCityPickerView(view: self, cityDidChange: (currentProvinceModel?.provinceName)!, city: (currentCityModel?.cityName)!, area: (currentAreaModel?.areaName)!)
        
    }
    
    


}






class YPBInputAccessoryView: UIView {
    
    typealias CustomClosures = (_ titleLabel: UILabel, _ cancleBtn: UIButton, _ doneBtn: UIButton) -> Void
    internal typealias BtnAction = () -> Void
    
    internal var title = "" {
        didSet {
            titleLable.text = title
        }
    }
    
    internal var doneAction: BtnAction?
    internal var cancelAction: BtnAction?
    
    private lazy var titleLable:UILabel = {
        let titleLable = UILabel()
        titleLable.text = ""
        titleLable.font = UIFont.systemFont(ofSize: 17)
        titleLable.textColor = UIColor.black
        titleLable.textAlignment = .center
        return titleLable
    }()
    
    // 取消按钮
    private(set) lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.sizeToFit()
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    // 完成按钮
    private(set) lazy var doneBtn: UIButton = {
        let donebtn = UIButton()
        donebtn.setTitle("完成", for: .normal)
        donebtn.sizeToFit()
        donebtn.setTitleColor(UIColor.black, for: .normal)
        return donebtn
    }()
    
    private lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = UIColor.white
        self.addSubview(cancleBtn)
        self.addSubview(titleLable)
        self.addSubview(doneBtn)
        self.addSubview(separateLine)
        
        cancleBtn.translatesAutoresizingMaskIntoConstraints = false
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        separateLine.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: cancleBtn,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: cancleBtn,
                                              attribute: NSLayoutAttribute.left,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.left,
                                              multiplier: 1.0,
                                              constant: 10))
        
        self.addConstraint(NSLayoutConstraint(item: doneBtn,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: doneBtn,
                                              attribute: NSLayoutAttribute.right,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.right,
                                              multiplier: 1.0,
                                              constant: -10))
        

        self.addConstraint(NSLayoutConstraint(item: titleLable,
                                              attribute: NSLayoutAttribute.centerX,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerX,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLable,
                                              attribute: NSLayoutAttribute.centerY,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))

        self.addConstraint(NSLayoutConstraint(item: separateLine,
                                              attribute: NSLayoutAttribute.left,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.left,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: separateLine,
                                              attribute: NSLayoutAttribute.right,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.right,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: separateLine,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: separateLine,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutAttribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 0.5))
        
    }
    
    
}

extension String {
    //将字符串转成富文本
    func toAttrString(font: UIFont, color: UIColor) -> NSAttributedString{
        
        let attr = [NSForegroundColorAttributeName: color,
                    NSFontAttributeName: font]
        
        let attrStr = NSAttributedString(string: self, attributes: attr)
        
        return attrStr
    }
    
}
