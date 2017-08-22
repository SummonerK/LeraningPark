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
    case orderListCreate(PostModel:ModelOrdersCreatePost)//MARK:批量创建订单
    case orderAddressSet(PostModel:ModelorderAddressSetPost)//MARK:订单设置地址
    case orderPay(PostModel:ModelOrderPayPost)//MARK:订单支付
    case orderListPay(PostModel:ModelOrdersPayPost)//MARK:订单批量支付
    case orderPayAccess(PostModel:ModelOrderPayAccessPost)//MARK:订单确认支付
    case orderListPayAccess(PostModel:ModelOrderPayAccessListPost)//MARK:订单批量确认支付
    case orderAccept(PostModel:ModelOrderAcceptPost)//MARK:订单接单
    
    //订单查询
    case orderNumbListByUser(PostModel:ModelOrderNumUserPost)//MARK:查询各状态订单数量
    case orderListByUser(PostModel:ModelListPageByUserPost)//MARK:分页查询用户全部订单明细
    case orderDetailByOid(PostModel:ModelOrderDetailPost)//MARK:根据订单ID查询订单详细信息
    case orderListByStatus(PostModel:ModelListPageByStatusPost)//MARK:根据状态查询用户订单明细（status为2是待支付，status为3是待发货，status为4是配送中）
    
    //购物车
    case shopShoppingCarAddProduct(PostModel:ModelShoppingCarAddProductPost)//MARK:购物车添加商品
    case shopShoppingCarProducts(PostModel:ModelShoppingCarProductsPost)//MARK:获取购物车
    case shopShoppingCarDeleteProduct(PostModel:ModelShoppingCarProductEditPost)//MARK:购物车删除商品
    case shopShoppingCarSetProductNum(PostModel:ModelShoppingCarProductEditPost)//MARK:购物车商品设置数量
    
}

extension orderAPI: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .test:
             return URLEncoding.default
            
        case .orderListByUser,.shopShoppingCarProducts,.orderListByStatus,.orderNumbListByUser,.orderDetailByOid:
            return URLEncoding.default
            
        case .orderCreate,.orderListCreate,.orderPay,.orderListPay,.orderPayAccess,.orderListPayAccess,.orderAccept,.orderAddressSet,.shopShoppingCarAddProduct,.shopShoppingCarDeleteProduct,.shopShoppingCarSetProductNum:
            return JSONEncoding.default
            
        }
    }
    
    var baseURL: URL {
        switch self {
        case .orderListCreate,.orderListPay,.orderListPayAccess:
            return URL(string: "http://118.89.190.166:9997")!
        default:
            return URL(string: baseorderpath)!
        }
        
//        return URL(string: baseorderpath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
            
        case .orderCreate(_):
            return "/Order/Create"
        case .orderListCreate(_):
            return "/Order/CreateOrders"
        case .orderAddressSet(_):
            return "/Order/Create"
        case .orderPay(_):
            return "/Order/Pay"
        case .orderPayAccess(_):
            return "/Order/PayAccess"
        case .orderListPay(_):
            return "/Order/PayOrders"
        case .orderListPayAccess(_):
            return "/Order/PayAccessOrders"
        case .orderAccept(_):
            return "/Order/Accept"
        case .orderNumbListByUser(_):
            return "/Query/Order/GetAllStatusCount"
        case .orderListByUser(_):
            return "/Query/Order/ListPageByUser"
        case .orderDetailByOid(_):
            return "/Query/Order/GetById"
        case .orderListByStatus(_):
            return "/Query/Order/ListByUserStatus"
        case .shopShoppingCarAddProduct(_):
            return "/ShoppingCart/AddProduct"
        case .shopShoppingCarProducts(_):
            return "/Query/ShoppingCart/ListUserAllShoppingCarts"
        case .shopShoppingCarDeleteProduct(_):
            return "/ShoppingCart/DelProduct"
        case .shopShoppingCarSetProductNum(_):
            return "/ShoppingCart/SetNumber"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .get
            
        case .orderCreate(_):
            return .post
        case .orderListCreate(_):
            return .post
        case .orderAddressSet(_):
            return .post
        case .orderPay(_):
            return .post
        case .orderPayAccess(_):
            return .post
        case .orderListPay(_):
            return .post
        case .orderListPayAccess(_):
            return .post
        case .orderAccept(_):
            return .post
        case .orderNumbListByUser(_):
            return .get
        case .orderListByUser(_):
            return .get
        case .orderDetailByOid(_):
            return .get
        case .orderListByStatus(_):
            return .get
        case .shopShoppingCarAddProduct(_):
            return .post
        case .shopShoppingCarProducts(_):
            return .get
        case .shopShoppingCarDeleteProduct(_):
            return .post
        case .shopShoppingCarSetProductNum(_):
            return .post
         
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
        case .orderListCreate(let model):
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
        case .orderListPay(let model):
            let dic = jsonToDictionary(jsonString: model.toJSONString()!)
            PrintFM(dic)
            return dic
        case .orderListPayAccess(let model):
            let dic = jsonToDictionary(jsonString: model.toJSONString()!)
            PrintFM(dic)
            return dic
        case .orderAccept(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderNumbListByUser(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderListByUser(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .orderDetailByOid(let model):
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
        case .shopShoppingCarDeleteProduct(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopShoppingCarSetProductNum(let model):
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
