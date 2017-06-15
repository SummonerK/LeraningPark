//
//  PreferenceKeys.swift
//  XfFruit
//
//  Created by 舒圆波 on 17/6/12.
//  Copyright © 2017年 舒圆波. All rights reserved.
//

import Foundation

final class PreferenceKey<T>: PreferenceKeys { }
class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}
extension PreferenceKeys {
    static let memberId = PreferenceKey<String>("MemberId")

}
