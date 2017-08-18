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
    //MARK:- 商户-商品
    case shopGetAllProducts(PostModel:ModelShopDetailPost)//MARK:获取门店商品
    case shopSearchProducts(PostModel:ModelSearchProductPost)//MARK:搜索门店商品
    case shopGetDetail(PostModel:ModelGoodsDetailPost)//MARK:获取商品详细信息 - 长图
    case shopGetDetailPictures(PostModel:ModelGoodsDetailPicturePost)//MARK:获取商品详细信息 - banner
    case shopGetDetailMenus(PostModel:ModelShopDetailMenuPost)//MARK:获取商品规格
    
    
    case addressGetList(PostModel:ModelAddressListPost)//MARK:
    
}

extension shopAPI: TargetType {

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .shopGetAllProducts,.addressGetList,.shopGetDetail,.shopGetDetailPictures,.shopGetDetailMenus,.shopSearchProducts:
            return URLEncoding.default
        case .test:
            return JSONEncoding.default
            
        }
    }

    var baseURL: URL {
        return URL(string: baseshoppath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
        case .shopGetAllProducts(_):
            return "/Query/Shop/ListAllProductsSort"
        case .shopSearchProducts(_):
            return "/Query/Shop/ListProductByNameSort"
        case .shopGetDetail(_):
            return "/Query/Product/GetDetail"
        case .shopGetDetailPictures(_):
            return "/Query/Product/ListPicture"
        case .shopGetDetailMenus(_):
            return "/Query/Product/ListBaseInfos"
            
            
        case .addressGetList(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .get
        case .shopGetAllProducts(_):
            return .get
        case .shopSearchProducts(_):
            return .get
        case .shopGetDetail(_):
            return .get
        case .shopGetDetailPictures(_):
            return .get
        case .shopGetDetailMenus(_):
            return .get
       
            
        case .addressGetList(_):
            return .get
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopGetAllProducts(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopSearchProducts(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopGetDetail(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopGetDetailPictures(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .shopGetDetailMenus(let model):
            PrintFM(model.toDict())
            return model.toDict()
        
            
        case .addressGetList(let model):
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
