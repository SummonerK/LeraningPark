//
//  shopAPI.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/30.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import Alamofire

enum shopAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 商户模块
    case shopGetNearList(PostModel:ModelAddressListPost)//MARK:获取获取门店列表
    case addressGetList(PostModel:ModelAddressListPost)//MARK:获取收货地址List
}

let baseshoppath = "http://118.89.192.122:9998"

extension shopAPI: TargetType {
    var baseURL: URL {
        return URL(string: baseshoppath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
        case .shopGetNearList(_):
            return "/Query/Shop/GetAllProducts"
        case .addressGetList(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .GET
        case .shopGetNearList(_):
            return .POST
        case .addressGetList(_):
            return .GET
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopGetNearList(let model):
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
