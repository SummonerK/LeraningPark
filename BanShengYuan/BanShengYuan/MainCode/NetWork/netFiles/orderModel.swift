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
    func orderNumbListByUser(amodel:ModelOrderNumUserPost) -> Observable<ModelOrderNumResult> {
        return orderprovider.request(.orderNumbListByUser(PostModel: amodel))
            .mapNeObject(type: ModelOrderNumResult.self)
        //.showError()
    }
    func orderListByUser(amodel:ModelListPageByUserPost) -> Observable<ModelOrderListResult> {
        return orderprovider.request(.orderListByUser(PostModel: amodel))
            .mapNeObject(type: ModelOrderListResult.self)
        //.showError()
    }
    func orderListByStatus(amodel:ModelListPageByStatusPost) -> Observable<ModelOrderListResult> {
        return orderprovider.request(.orderListByStatus(PostModel: amodel))
            .mapNeObject(type: ModelOrderListResult.self)
        //.showError()
    }
    func shopShoppingCarAddProduct(amodel:ModelShoppingCarAddProductPost) -> Observable<ModelShoppingCarAddResult> {
        return orderprovider.request(.shopShoppingCarAddProduct(PostModel: amodel))
            .mapNeObject(type: ModelShoppingCarAddResult.self)
    }
    func shopShoppingCarProducts(amodel:ModelShoppingCarProductsPost) -> Observable<ModelShoppingCarProductsResult> {
        return orderprovider.request(.shopShoppingCarProducts(PostModel: amodel))
            .mapNeObject(type: ModelShoppingCarProductsResult.self)
    }

    func shopShoppingCarDeleteProduct(amodel:ModelShoppingCarProductEditPost) -> Observable<ModelShoppingCarAddResult> {
        return orderprovider.request(.shopShoppingCarDeleteProduct(PostModel: amodel))
            .mapNeObject(type: ModelShoppingCarAddResult.self)
    }
    func shopShoppingCarSetProductNum(amodel:ModelShoppingCarProductEditPost) -> Observable<ModelShoppingCarAddResult> {
        return orderprovider.request(.shopShoppingCarSetProductNum(PostModel: amodel))
            .mapNeObject(type: ModelShoppingCarAddResult.self)
    }
}
