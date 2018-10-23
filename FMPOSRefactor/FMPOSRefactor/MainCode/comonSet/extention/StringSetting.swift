//
//  StringSetting.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/19.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation


extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
