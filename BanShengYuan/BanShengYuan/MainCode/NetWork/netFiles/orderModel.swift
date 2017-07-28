//
//  orderModel.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya

let orderheaderFields: Dictionary<String, String> = [
    "Content-Type": "application/x-www-form-urlencoded",
    //    "sys_ver": String(UIDevice.version())
]

let orderappendedParams: Dictionary<String, AnyObject> = [
    "uid": "123456" as AnyObject
]

let orderendpoint = { (target: orderAPI) -> Endpoint<orderAPI> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint<orderAPI>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        //        .endpointByAddingParameters(appendedParams)
        .adding(newHTTPHeaderFields: headerFields)
}

let orderapiProvider = RxMoyaProvider<orderAPI>(endpointClosure:orderendpoint,plugins:[loadingPlugin,logPlugin])

let orderprovider = RxMoyaProvider<orderAPI>(plugins:[loadingPlugin,logPlugin])

class orderModel {
    
    func TESTHttps(amodel:ModelTestPost) -> Observable<ModelTestBack> {
        return orderprovider.request(.test(PostModel: amodel))
            .mapObject(type: ModelTestBack.self)
        //.showError()
    }
    
    func orderCreate(amodel:ModelOrderCreatePost) -> Observable<ModelOrderCreateBack> {
        return orderprovider.request(.orderCreate(PostModel: amodel))
            .mapNeObject(type: ModelOrderCreateBack.self)
        //.showError()
    }
    func orderAddressSet(amodel:ModelorderAddressSetPost) -> Observable<ModelorderAddressSetBack> {
        return orderprovider.request(.orderAddressSet(PostModel: amodel))
            .mapNeObject(type: ModelorderAddressSetBack.self)
        //.showError()
    }
    func orderPay(amodel:ModelOrderPayPost) -> Observable<modelPayPlanBack> {
        return orderprovider.request(.orderPay(PostModel: amodel))
            .mapNeObject(type: modelPayPlanBack.self)
        //.showError()
    }
    
    func orderPayAccess(amodel:ModelOrderPayAccessPost) -> Observable<ModelOrderPayAccessBack> {
        return orderprovider.request(.orderPayAccess(PostModel: amodel))
            .mapNeObject(type: ModelOrderPayAccessBack.self)
        //.showError()
    }
    func orderAccept(amodel:ModelOrderAcceptPost) -> Observable<ModelCommonBack> {
        return orderprovider.request(.orderAccept(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
        //.showError()
    }
    func orderListByUser(amodel:ModelListPageByUserPost) -> Observable<ModelOrderWithCount> {
        return orderprovider.request(.orderListByUser(PostModel: amodel))
            .mapResult(type: ModelOrderWithCount.self)
        //.showError()
    }
    
}
