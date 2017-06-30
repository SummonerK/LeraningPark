//
//  API.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import RxSwift
import Moya
import Alamofire

func jsonToDictionary(jsonString:String) -> [String:Any] {
    
    let jsonData:Data  = jsonString.data(using: .utf8)!
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! [String:Any]
    }
    return NSDictionary() as! [String : Any]
}

enum MyAPI {
    case test(PostModel:ModelTestPost)//测试https
    //MARK:- 登录模块
    case loginLogin(PostModel:ModelLoginPost)//MARK:登录
    case loginGetVCode(PostModel:ModelVCodePost)//MARK:获取验证码
    case loginRegister(PostModel:ModelRegisterPost)//MARK:注册
    case loginUpdatePWD(PostModel:ModelUpdatePwdPost)//MARK:修改密码
    //MARK:- 收货地址模块
    case addressGetList(PostModel:ModelAddressListPost)//MARK:获取收货地址List
    case addressGetDetail(PostModel:ModelAddressDetailPost)//MARK:获取收货地址详情
    case addressUpdate(PostModel:ModelAddressUpdatePost)//MARK:收货地址新增／修改
    case addressAdd(PostModel:ModelAddressAddPost)//MARK:收货地址新增／修改
    case addressDelete(PostModel:ModelAddressDeletePost)//MARK:收货地址删除
    //MARK:- 用户信息模块
    case userUpdate(PostModel:ModelUserUpdateInfoPost)//MARK:个人信息设置
}

let basepath = "http://115.159.124.30:8735"

//let basepath = "https://api.github.com"

extension MyAPI: TargetType {
    var baseURL: URL {
        return URL(string: basepath)!
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
        case .loginLogin(_):
            return "/member/login"
        case .loginGetVCode(_):
            return "/member/sms"
        case .loginRegister(_):
            return "/member/register"
        case .loginUpdatePWD(_):
            return "/member/updatePwd"
        case .addressGetList(_):
            return "/member/deliveraddress/list"
        case .addressGetDetail(_):
            return "/member/deliveraddress"
        case .addressUpdate(_):
            return "/member/deliveraddress"
        case .addressAdd(_):
            return "/member/deliveraddress"
        case .addressDelete(_):
            return "/member/deliveraddress"
        case .userUpdate(_):
            return "/member/info"
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .loginLogin,.test,.loginGetVCode,.addressGetList,.addressGetDetail:
            return URLEncoding.default
        case .loginRegister,.loginUpdatePWD,.addressUpdate,.addressDelete,.userUpdate,.addressAdd:
            return JSONEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test(_):
            return .GET
        case .loginLogin(_):
            return .GET
        case .loginGetVCode(_):
            return .GET
        case .loginRegister(_):
            return .POST
        case .loginUpdatePWD(_):
            return .POST
        case .addressGetList(_):
            return .GET
        case .addressGetDetail(_):
            return .GET
        case .addressUpdate(_):
            return .POST
        case .addressAdd(_):
            return .POST
        case .addressDelete(_):
            return .DELETE
        case .userUpdate(_):
            return .POST
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .loginLogin(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .loginGetVCode(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .loginRegister(let model):
            
            let request = jsonToDictionary(jsonString: model.description)
            return request
        case .loginUpdatePWD(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressGetList(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressGetDetail(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressUpdate(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressAdd(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .addressDelete(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .userUpdate(let model):
            PrintFM(model.toDict())
            return model.toDict()
        }
    }
    
    var sampleData: Data {
        switch self {
        case .test(_):
            return "test successfully".data(using: String.Encoding.utf8)!
        default:
            return "API successfully".data(using: String.Encoding.utf8)!
        }
        
    }
    
    // MARK: URLRequestConvertible
    
    var task: Task {
        return .request
    }
    
}
