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

enum MyAPI {
    //MARK:- 登录模块
    case loginLogin(PostModel:ModelLoginPost)//MARK:登录
    case loginGetVCode(PostModel:ModelVCodePost)//MARK:获取验证码
    case loginRegister(PostModel:ModelRegisterPost)//MARK:注册
    case loginUpdatePWD(PostModel:ModelUpdatePwdPost)//MARK:修改密码
    //MARK:- 收货地址模块
    case addressGetList(PostModel:ModelAddressListPost)//MARK:获取收货地址List
    case addressGetDetail(PostModel:ModelAddressDetailPost)//MARK:获取收货地址详情
    case addressUpdate(PostModel:ModelAddressUpdatePost)//MARK:收货地址新增／修改
    case addressDelete(PostModel:ModelAddressDeletePost)//MARK:收货地址删除
    //MARK:- 用户信息模块
    case userUpdate(PostModel:ModelUserUpdateInfoPost)//MARK:个人信息设置
}

let basepath = "http://115.159.124.30:8735"

extension MyAPI: TargetType {
    var baseURL: URL {
        return URL(string: basepath)!
    }
    
    var path: String {
        switch self {
        case .loginLogin(_):
            return "/member/login"
        case .loginGetVCode(_):
            return ""
        case .loginRegister(_):
            return ""
        case .loginUpdatePWD(_):
            return ""
        case .addressGetList(_):
            return ""
        case .addressGetDetail(_):
            return ""
        case .addressUpdate(_):
            return "/member/deliveraddress"
        case .addressDelete(_):
            return ""
        case .userUpdate(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
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
        case .addressDelete(_):
            return .DELETE
        case .userUpdate(_):
            return .POST
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .loginLogin(let model):
            PrintFM(model.toDict())
            return model.toDict()
        case .loginGetVCode(let model):
            return model.toDict()
        case .loginRegister(let model):
            return model.toDict()
        case .loginUpdatePWD(let model):
            return model.toDict()
        case .addressGetList(let model):
            return model.toDict()
        case .addressGetDetail(let model):
            return model.toDict()
        case .addressUpdate(let model):
            return model.toDict()
        case .addressDelete(let model):
            return model.toDict()
        case .userUpdate(let model):
            return model.toDict()
        }
    }
    
    var sampleData: Data {
        switch self {
        case .loginLogin(_):
            return "Create post successfully".data(using: String.Encoding.utf8)!
        default:
            return "Create post successfully".data(using: String.Encoding.utf8)!

        }
        
    }
    
    var task: Task {
        return .request
    }
    
}
