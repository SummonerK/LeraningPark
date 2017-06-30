//
//  vipModel.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/30.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let vipheaderFields: Dictionary<String, String> = [
    "Content-Type": "application/x-www-form-urlencoded",
//    "sys_ver": String(UIDevice.version())
]

let vipappendedParams: Dictionary<String, AnyObject> = [
    "uid": "123456" as AnyObject
]

let vipendpoint = { (target: vipAPI) -> Endpoint<vipAPI> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
//        .endpointByAddingParameters(appendedParams)
        .endpointByAddingHTTPHeaderFields(headerFields)
}

let vipapiProvider = RxMoyaProvider<vipAPI>(endpointClosure:vipendpoint,plugins:[loadingPlugin,logPlugin])

let vipprovider = RxMoyaProvider<vipAPI>(plugins:[loadingPlugin,logPlugin])

class vipModel {
    
    func TESTHttps(amodel:ModelTestPost) -> Observable<ModelTestBack> {
        return vipprovider.request(.test(PostModel: amodel))
            .mapObject(type: ModelTestBack.self)
            .showError()
    }
    
    func vipgetShopList(amodel:ModelShopListPost) -> Observable<[ModelShopItem]> {
        return vipprovider.request(.vipgetShopList(PostModel: amodel))
            .mapshopList(type: ModelShopItem.self)
            .showError()
    }
    func addressGetList(amodel:ModelAddressListPost) -> Observable<ModelAddressDetail> {
        return vipprovider.request(.addressGetList(PostModel: amodel))
            .mapObject(type: ModelAddressDetail.self)
            .showError()
    }
    
}
