//
//  ProvinceModel.swift
//  home
//
//  Created by 袁利伟 on 16/6/2.
//  Copyright © 2016年 venusourceyuan. All rights reserved.
//

import UIKit


class ProvinceModel: NSObject {
    
    var id:String?
    var provinceName:String?
    var citylist:[CityModel]?
    
    class func loadCityCodModel() ->([ProvinceModel]) {
        let file = Bundle.main.path(forResource: "citydatacoding", ofType: "plist")!
        var tempArray:[ProvinceModel] = []
        let dataArray = NSArray(contentsOfFile: file)
        for dic in dataArray! {
            let provinceModel = ProvinceModel(dic: dic as! [String : AnyObject])
            tempArray.append(provinceModel)
        }
        return tempArray
    }
    
    init(dic:[String:AnyObject]) {
        super.init()
        self.setValuesForKeys(dic)
        if let arr = dic["citylist"] {
            let dicarr = arr  as! [[String:AnyObject]]
            var tempArray:[CityModel] = []
            for dic in dicarr {
                let cityModel = CityModel(dic: dic)
                tempArray.append(cityModel)
            }
            citylist = tempArray
        }
   
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    

}


class CityModel: NSObject {
    var id:String?
    var cityName:String?
    var arealist:[AreaModel]?
    init(dic:[String:AnyObject]) {
        super.init()
        self.setValuesForKeys(dic)
        if let arr = dic["arealist"] {
            let dicarr = arr  as! [[String:AnyObject]]
            var tempArray:[AreaModel] = []
            for dic in dicarr {
                let areamodel = AreaModel(dic: dic)
                tempArray.append(areamodel)
            }
            arealist = tempArray
            
        }
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

    
    
    
}

class AreaModel: NSObject {
    var id:String?
    var areaName:String?
    init(dic:[String:AnyObject]) {
        super.init()
        self.setValuesForKeys(dic)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}


