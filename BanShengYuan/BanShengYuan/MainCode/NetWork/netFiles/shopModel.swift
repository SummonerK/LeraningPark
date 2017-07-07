//
//  shopModel.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/30.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let PARTNERID = "53c69e54-c788-495c-bed3-2dbfc6fd5c61"

let shopheaderFields: Dictionary<String, String> = [
    "platform": "iOS",
    "sys_ver": String(UIDevice.version())
]

let shopappendedParams: Dictionary<String, AnyObject> = [
    "uid": "123456" as AnyObject
]

let shopendpoint = { (target: shopAPI) -> Endpoint<shopAPI> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint<shopAPI>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        .adding(newParameters: appendedParams)
        .adding(newHTTPHeaderFields: headerFields)
}

let shopapiProvider = RxMoyaProvider<shopAPI>(endpointClosure:shopendpoint,plugins:[loadingPlugin,logPlugin])

let shopprovider = RxMoyaProvider<shopAPI>(plugins:[loadingPlugin,logPlugin])

class shopModel {
    
    func TESTHttps(amodel:ModelTestPost) -> Observable<ModelTestBack> {
        return shopprovider.request(.test(PostModel: amodel))
            .mapObject(type: ModelTestBack.self)
            //.showError()
    }
    
    func addressGetList(amodel:ModelAddressListPost) -> Observable<[ModelAddressItem]> {
        return shopprovider.request(.addressGetList(PostModel: amodel))
            .mapArray(type: ModelAddressItem.self)
            //.showError()
    }
    func shopGetAllProducts(amodel:ModelShopDetailPost) -> Observable<[ModelShopDetailItem]> {
        return shopprovider.request(.shopGetAllProducts(PostModel: amodel))
            .mapShopDetailProductList(type: ModelShopDetailItem.self)
            //.showError()
    }
    func shopGetDetail(amodel:ModelGoodsDetailPost) -> Observable<ModelGoodsDetailResult> {
        return shopprovider.request(.shopGetDetail(PostModel: amodel))
            .mapResult(type: ModelGoodsDetailResult.self)
        //.showError()
    }
    func shopGetDetailPictures(amodel:ModelGoodsDetailPicturePost) -> Observable<[ModelGoodsDetailResultPictures]> {
        return shopprovider.request(.shopGetDetailPictures(PostModel: amodel))
            .mapResultList(type: ModelGoodsDetailResultPictures.self)
        //.showError()
    }
    
}
