//
//  baseClass.swift
//  RxSwiftMoya
//
//  Created by Luofei on 2017/6/15.
//  Copyright © 2017年 ERStone. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class baseClass{
    
    var name:String?
    
    func baseClassDS() -> String{
        
        let json = JSON.init(["121","456"])
        
        print("-----\(String(describing: json.array))")
        
        let json1 = JSON.init(self as! [String:Any])
        
        print("-----\(String(describing: json1.dictionary))")
        
        
        return ""
    }
}
