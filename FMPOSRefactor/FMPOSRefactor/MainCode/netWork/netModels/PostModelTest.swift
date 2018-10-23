//
//  PostModelTest.swift
//  banshengyuan-jishi
//
//  Created by Luofei on 2017/11/14.
//  Copyright © 2017年 FreeMud. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK:通用model 结构
/*
 *  statusCode:100
 *  msg:String
 */
class ModelTestPost: Mappable {
    var key: String?

    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        key <- map["key"]
    }
    
}

class ModelLoadFile: Mappable {
    var key: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        key <- map["key"]
    }
    
}

func jsonToDictionary(jsonString:String) -> [String:Any] {
    
    let jsonData:Data  = jsonString.data(using: .utf8)!
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! [String:Any]
    }
    return NSDictionary() as! [String : Any]
}

extension Mappable{
    var DicValue:[String: Any]?{
        
        var dic = jsonToDictionary(jsonString: self.toJSONString()!)
        
        PrintFM("Params : \n\(dic)")
        for (key,value) in dic {
            if (value as AnyObject).isKind(of: NSArray.self){
                let array: NSArray = value as! NSArray
                var newValue: String = ""
                for i  in 0 ..< array.count{
                    
                    if i == 0 {
                        newValue = "\(array[i])"
                    }else {
                        newValue = "\(newValue),\(array[i])"
                    }
                    dic[key] = newValue
                }
//                dic.removeValue(forKey: key)
            }
        }
        PrintFM("NewParams : \n\(dic)")
        return dic
    }
    
    var DicArrayValue:[String: Any]?{
        let dic = jsonToDictionary(jsonString: self.toJSONString()!)
        return dic
    }
}

//MARK:通用返回结构
/*
 *  statusCode:100
 *  msg:String
 */
class ModelCommonBack: Mappable {
    var msg: String?
    var ret: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        ret <- map["ret"]
    }
    
    public var description: String {
        return self.msg!
    }
    
}
