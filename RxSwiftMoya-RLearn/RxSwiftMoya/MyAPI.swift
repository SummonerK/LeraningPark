//
//  MyAPI.swift
//  RxSwiftMoya
//
//  Created by Chao Li on 9/20/16.
//  Copyright © 2016 ERStone. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum MyAPI {
    case Show
    case Create(title: String, body: String, userId: Int)
    case getVerifyCode(ctel: String, type: String)
}

let basepath = "http://112.124.113.234:8080/zhizuobang-wap/"


extension MyAPI: TargetType {
    var baseURL: URL {
        return URL(string: basepath)!
    }
    
    var path: String {
        switch self {
        case .Show:
            return "/posts"
        case .Create(_, _, _):
            return "/post"
        case .getVerifyCode(_, _):
            return "user/getVerifyCode"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Show:
            return .GET
        case .Create(_, _, _):
            return .POST
        case .getVerifyCode(_, _):
            return.POST
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .Show:
            return nil
        case .Create(let title, let body, let userId):
            return ["title": title, "body": body, "userId": userId]
            
        case .getVerifyCode(let cTel, let type):
            return ["cTel":cTel ,"type":type,"data":["key":"value"]]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .Show:
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .Create(_, _, _):
            return "Create post successfully".data(using: String.Encoding.utf8)!
        case .getVerifyCode(_, _) :
            return "Create post successfully".data(using: String.Encoding.utf8)!
        }
        
    }
    
    var task: Task {
        return .request
    }
    
}
