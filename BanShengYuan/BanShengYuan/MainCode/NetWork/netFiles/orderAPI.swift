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

enum orderAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 订单
    case orderCreate(PostModel:ModelOrderCreatePost)//MARK:订单创建
    case orderPay(PostModel:ModelGoodsDetailPost)//MARK:订单支付
    case orderPayAccess(PostModel:ModelGoodsDetailPicturePost)//MARK:订单确认支付
    case orderAccept(PostModel:ModelGoodsDetailPicturePost)//MARK:订单接单
    case orderListByUserStatus(PostModel:ModelGoodsDetailPicturePost)//MARK:根据状态查询用户订单明细
    case orderListByUser(PostModel:ModelGoodsDetailPicturePost)//MARK:分页查询用户全部订单明细
    
}

let baseorderpath = "http://118.89.192.122:9997"

extension orderAPI: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .test:
             return URLEncoding.default
            
        case .orderPay,.orderPayAccess,.orderAccept,.orderListByUserStatus,.orderListByUser:
            return URLEncoding.default
            
        case .orderCreate:
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
        case .orderPay(_):
            return ""
        case .orderPayAccess(_):
            return ""
        case .orderAccept(_):
            return ""
        case .orderListByUserStatus(_):
            return ""
        case .orderListByUser(_):
            return ""
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .get
            
        case .orderCreate(_):
            return .post
        case .orderPay(_):
            return .get
        case .orderPayAccess(_):
            return .get
        case .orderAccept(_):
            return .get
        case .orderListByUserStatus(_):
            return .get
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
        case .orderListByUserStatus(let model):
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
