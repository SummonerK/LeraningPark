//
//  baseClass.swift
//  Hello world
//
//  Created by Luofei on 2017/6/15.
//  Copyright © 2017年 luofei. All rights reserved.
//

import Foundation
import ObjectMapper

class baseClass : Mappable{
    
    var name:String?
    
    func DS() -> String {
        return self.toJSONString()!
    }
    

}
