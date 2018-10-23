//
//  PayApi.swift
//  FMPOS-Master
//
//  Created by 舒圆波 on 18/7/31.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SVProgressHUD

enum PayApi {
    case reqPay(req:PayReq)                         //支付
    case reqRefund(req: PayReq)                     //退款
    case reqQueryPay(req:PayReq)                    //查询
    
}



extension PayApi:TargetType {
    var baseURL: URL {
        return URL(string: payBasePath)!
    }
    
    var path: String {
        return "api"
    }
    
    var method: Moya.Method {
        switch self {
        case .reqPay,.reqRefund,.reqQueryPay:
            return .post
        default:
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .reqPay(req),let .reqRefund(req),let .reqQueryPay(req):
            return req.DicArrayValue
        }
        
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .reqPay,.reqRefund,.reqQueryPay:
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
