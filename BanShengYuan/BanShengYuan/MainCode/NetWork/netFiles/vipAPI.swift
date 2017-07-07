//
//  vipAPI.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/30.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import Alamofire

let shipid = "178a14ba-85a8-40c7-9ff4-6418418f5a0c_31310040"

enum vipAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 商户
    case vipgetShopList(PostModel:ModelShopListPost)//MARK:获取获取门店列表
    case addressGetList(PostModel:ModelAddressListPost)//MARK:
}

let basevippath = "http://console.freemudvip.com/service/restful/base"

extension vipAPI: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .test,.addressGetList:
            return URLEncoding.default
        case .vipgetShopList:
            return JSONEncoding.default
        }
    }

    var baseURL: URL {
        return URL(string: basevippath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
        case .vipgetShopList(_):
            return ""
        case .addressGetList(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .get
        case .vipgetShopList(_):
            return .post
        case .addressGetList(_):
            return .get
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            return model.toDict()
        case .vipgetShopList(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressGetList(let model):
            return model.toDict()
        }
    }
    
    var sampleData: Data {
        switch self {
        case .test(_):
            return "test successfully".data(using: String.Encoding.utf8)!
        default:
            return "shopAPI successfully".data(using: String.Encoding.utf8)!
        }
        
    }
    
    var task: Task {
        return .request
    }
    
}
