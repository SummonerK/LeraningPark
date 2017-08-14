//
//  qiniu.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/6.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import Alamofire

let upPath = ""


enum QNAPI {
    case UpLoad(PostModel:ModelTestPost)//测试https

}

extension QNAPI: TargetType {
    var baseURL: URL {
        return URL(string: upPath)!
    }
    
    var path: String {
        switch self {
        case .UpLoad(_):
            return ""
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        PrintFM("parameterEncoding")
        switch self {
        case .UpLoad:
            return URLEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .UpLoad(_):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .UpLoad(let model):
            PrintFM(model.toDict())
            return model.toDict()
        }
    }
    
    
    var sampleData: Data {
        PrintFM("")
        switch self {
        case .UpLoad(_):
            return "UpLoad successfully".data(using: .utf8)!
        }
        
    }
    
    // MARK: URLRequestConvertible
    
    var task: Task {
        return .request
    }
    
}
