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
let wxPay_ebcode = "10004"

enum orderAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 订单
    case orderCreate(PostModel:ModelOrderCreatePost)//MARK:订单创建
    case orderAddressSet(PostModel:ModelorderAddressSetPost)//MARK:订单设置地址
    case orderPay(PostModel:ModelOrderPayPost)//MARK:订单支付
    case orderPayAccess(PostModel:ModelOrderPayAccessPost)//MARK:订单确认支付
    case orderAccept(PostModel:ModelOrderAcceptPost)//MARK:订单接单
    case orderListByUser(PostModel:ModelListPageByUserPost)//MARK:分页查询用户全部订单明细
    case orderListByStatus(PostModel:ModelListPageByStatusPost)//MARK:根据状态查询用户订单明细（status为2是待支付，status为3是待发货，status为4是配送中）
    
    //购物车
    case shopShoppingCarAddProduct(PostModel:ModelShoppingCarAddProductPost)//MARK:购物车添加商品
    case shopShoppingCarProducts(PostModel:ModelShoppingCarProductsPost)//MARK:获取购物车
    
}

extension orderAPI: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .test:
             return URLEncoding.default
            
        case .orderListByUser,.shopShoppingCarProducts,.orderListByStatus:
            return URLEncoding.default
            
        case .orderCreate,.orderPay,.orderPayAccess,.orderAccept,.orderAddressSet,.shopShoppingCarAddProduct:
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
        case .orderListByStatus(_):
            return "/Query/Order/ListByUserStatus"
        case .shopShoppingCarAddProduct(_):
            return "/ShoppingCart/AddProduct"
        case .shopShoppingCarProducts(_):
            return "/Query/ShoppingCart/ListUserAllShoppingCarts"
        
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
        case .orderListByStatus(_):
            return .get
        case .shopShoppingCarAddProduct(_):
            return .post
        case .shopShoppingCarProducts(_):
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
        case .orderListByStatus(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopShoppingCarAddProduct(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopShoppingCarProducts(let model):
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
