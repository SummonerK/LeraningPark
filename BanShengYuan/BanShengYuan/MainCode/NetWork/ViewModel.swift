//
//  ViewModel.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import RxSwift
import Moya

let headerFields: Dictionary<String, String> = [
    "platform": "iOS",
    "sys_ver": String(UIDevice.version())
]

let appendedParams: Dictionary<String, AnyObject> = [
    "uid": "123456" as AnyObject
]

let endpoint = { (target: MyAPI) -> Endpoint<MyAPI> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        .endpointByAddingParameters(appendedParams)
        .endpointByAddingHTTPHeaderFields(headerFields)
    
}

class ViewModel {

    let apiProvider = RxMoyaProvider<MyAPI>(endpointClosure:endpoint)
    
    private let provider = RxMoyaProvider<MyAPI>()
    
    func loginLogin(amodel:ModelLoginPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginLogin(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func loginGetVCode(amodel:ModelVCodePost) -> Observable<ModelCommonBack> {
        return provider.request(.loginGetVCode(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func loginRegister(amodel:ModelRegisterPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginRegister(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func loginUpdatePWD(amodel:ModelUpdatePwdPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginUpdatePWD(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func addressGetList(amodel:ModelAddressListPost) -> Observable<[ModelAddressItem]> {
        return provider.request(.addressGetList(PostModel: amodel))
            .mapArray(type: ModelAddressItem.self)
            .showError()
    }
    func addressGetDetail(amodel:ModelAddressDetailPost) -> Observable<ModelAddressDetail> {
        return provider.request(.addressGetDetail(PostModel: amodel))
            .mapObject(type: ModelAddressDetail.self)
            .showError()
    }
    func addressUpdate(amodel:ModelAddressUpdatePost) -> Observable<ModelCommonBack> {
        return provider.request(.addressUpdate(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func addressDelete(amodel:ModelAddressDeletePost) -> Observable<ModelCommonBack> {
        return provider.request(.addressDelete(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    func userUpdate(amodel:ModelUserUpdateInfoPost) -> Observable<ModelCommonBack> {
        return provider.request(.userUpdate(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            .showError()
    }
    
}

//MARK:-statusMapping 监控Error
public extension Observable {
    func showError() -> Observable<Element> {
        return self.doOn {event in
            switch event{
            case .error(let e):
                print("showError \(e)")
            default:
                print("default")
            }
        }
    }
}
