//
//  AccountApi.swift
//  FMPOS-Master
//
//  Created by 舒圆波 on 18/7/30.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SVProgressHUD

enum AccountApi {
    case reqBindAccount(req:BindReq)                 //绑定商户
    case reqLogin(req: LoginReq)                 //登录
    case reqUpdateInfo(req:UpdateReq)               //获取更新信息
    case appstoreInfo()
}

extension AccountApi:TargetType {
    var baseURL: URL {
        switch self {
        case .appstoreInfo:
            return URL(string: itunesPath)!
        default:
            return URL(string: accountBasepath)!
        }
    }
    
    var path: String {
        switch self {
        case .appstoreInfo:
            return ""
        default:
            return "service/restful/device"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reqBindAccount,.reqLogin,.reqUpdateInfo:
            return .post
        default:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .reqLogin(req):
            return req.DicValue
        case let .reqBindAccount(req):
            return req.DicValue
        case let .reqUpdateInfo(req):
            return req.DicValue
        case .appstoreInfo():
            return nil
        }
        
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .reqBindAccount,.reqLogin,.reqUpdateInfo,.appstoreInfo:
            return JSONEncoding.default
        default :
            return URLEncoding.default
        }
    }
    
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        return .request
    }
    
    
    
}
