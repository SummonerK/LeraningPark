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
    "Content-Type": "application/json"
]

let appendedParams: Dictionary<String, AnyObject> = [
    "Content-Type": "application/x-www-form-urlencoded" as AnyObject
]

let endpoint = { (target: MyAPI) -> Endpoint<MyAPI> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint<MyAPI>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
//        .endpointByAddingParameters(appendedParams)
        .adding(newHTTPHeaderFields: headerFields)
}

//let apiProvider = RxMoyaProvider<MyAPI>(endpointClosure:endpoint,plugins:[loadingPlugin,logPlugin])

let provider = RxMoyaProvider<MyAPI>(plugins:[loadingPlugin,logPlugin])

class ViewModel {
    
    func TESTHttps(amodel:ModelTestPost) -> Observable<ModelTestBack> {
        return provider.request(.test(PostModel: amodel))
            .mapObject(type: ModelTestBack.self)
            //.showError()
    }

    func loginLogin(amodel:ModelLoginPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginLogin(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func loginGetVCode(amodel:ModelVCodePost) -> Observable<ModelCommonBack> {
        return provider.request(.loginGetVCode(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func loginVCodeVerify(amodel:ModelVCodeVerifyPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginVCodeVerify(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func loginRegister(amodel:ModelRegisterPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginRegister(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func loginUpdatePWD(amodel:ModelUpdatePwdPost) -> Observable<ModelCommonBack> {
        return provider.request(.loginUpdatePWD(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func addressGetList(amodel:ModelAddressListPost) -> Observable<[ModelAddressItem]> {
        return provider.request(.addressGetList(PostModel: amodel))
            .mapAddList(type: ModelAddressItem.self)
            //.showError()
    }
    func addressGetDetail(amodel:ModelAddressDetailPost) -> Observable<ModelAddressDetail> {
        return provider.request(.addressGetDetail(PostModel: amodel))
            .mapObject(type: ModelAddressDetail.self)
            //.showError()
    }
    func addressUpdate(amodel:ModelAddressUpdatePost) -> Observable<ModelCommonBack> {
        return provider.request(.addressUpdate(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func addressAdd(amodel:ModelAddressAddPost) -> Observable<ModelCommonBack> {
        return provider.request(.addressAdd(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func addressDelete(amodel:ModelAddressDeletePost) -> Observable<ModelCommonBack> {
        return provider.request(.addressDelete(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    func userUpdate(amodel:ModelUserUpdateInfoPost) -> Observable<ModelCommonBack> {
        return provider.request(.userUpdate(PostModel: amodel))
            .mapObject(type: ModelCommonBack.self)
            //.showError()
    }
    
}

//MARK:-statusMapping 监控Error
public extension Observable {
    func showError() -> Void {
//
//         self.subscribe(onError: {event in
//            switch event{
//                            case Error(let e):
//                                print("showError \(e)")
//                            default:
//                                print("default")
//                            }
//        })
    }
}
