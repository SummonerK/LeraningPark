//
//  orderAPI.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import Alamofire

let aliPay_ebcode = "10001"

enum orderAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 订单
    case orderCreate(PostModel:ModelOrderCreatePost)//MARK:订单创建
    case orderAddressSet(PostModel:ModelorderAddressSetPost)//MARK:订单设置地址
    case orderPay(PostModel:ModelOrderPayPost)//MARK:订单支付
    case orderPayAccess(PostModel:ModelOrderPayAccessPost)//MARK:订单确认支付
    case orderAccept(PostModel:ModelOrderAcceptPost)//MARK:订单接单
    case orderListByUser(PostModel:ModelListPageByUserPost)//MARK:分页查询用户全部订单明细
    
}
//9997
let baseorderpath = "http://mallapi.sandload.cn"

extension orderAPI: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .test:
             return URLEncoding.default
            
        case .orderListByUser:
            return URLEncoding.default
            
        case .orderCreate,.orderPay,.orderPayAccess,.orderAccept,.orderAddressSet:
            return JSONEncoding.default
            
        }
    }
    
    var baseURL: URL {
        return URL(string: baseorderpath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
            
        case .orderCreate(_):
            return "/Order/Create"
        case .orderAddressSet(_):
            return "/Order/Create"
        case .orderPay(_):
            return "/Order/Pay"
        case .orderPayAccess(_):
            return "/Order/PayAccess"
        case .orderAccept(_):
            return "/Order/Accept"
        case .orderListByUser(_):
            return "/Query/Order/ListPageByUser"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .get
            
        case .orderCreate(_):
            return .post
        case .orderAddressSet(_):
            return .post
        case .orderPay(_):
            return .post
        case .orderPayAccess(_):
            return .post
        case .orderAccept(_):
            return .post
        case .orderListByUser(_):
            return .get
         
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            PrintFM(model.toDict())
            return model.toDict()
            
        case .orderCreate(let model):
            let dic = jsonToDictionary(jsonString: model.toJSONString()!)
            PrintFM(dic)
            return dic
        case .orderAddressSet(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderPay(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderPayAccess(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderAccept(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderListByUser(let model):
            PrintFM(model.toDict())
            return model.toDict()
            
        }
    }
    
    var sampleData: Data {
        PrintFM("")
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
