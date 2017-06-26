//
//  Observable+ObjectMapper.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/26.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import UIKit
import SwiftyJSON

public protocol Mapable {
    init?(jsonData:JSON)
}

let RESULT_CODE = "statusCode"  //约定的code格式
let RESULT_MSG = "msg"     //约定的msg格式


protocol ErrorType {
    var _domain: Swift.String { get }
    var _code: Swift.Int { get }
}

struct MyErrorStruct : ErrorType {
    let _domain: String
    let _code: Int
}

class MyErrorClass : ErrorType {
    let _domain: String
    let _code: Int
    
    init(domain: String, code: Int) {
        _domain = domain
        _code = code
    }
}

struct GoodError : ErrorType {
    let domain: String
    let code: Int
    
    var _domain: String {
        return domain
    }
    var _code: Int {
        return code
    }
}

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            // check http status
            guard let response = response as? Moya.Response else{
                throw RxSwiftMoyaError.NoRepresentor
            }
            guard ((100...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.NotSuccessfulHTTP
            }
            //
            //json shell
            let json = JSON.init(data: response.data)
            print("\(json)")
            print("\(String(describing: json[RESULT_CODE].int))")
            print("\(String(describing: json[RESULT_MSG].string))")
            
            
            if json[RESULT_CODE].int == Int(RxSwiftMoyaError.IBSuccess.rawValue){
                
                guard let dict = json.rawValue as? [String: Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                return Mapper<T>().map(JSON: dict)!
                
            }else{
                
                throw MyErrorEnum.IBError(Code: json[RESULT_CODE].int!, Msg: json[RESULT_MSG].string!)
            }

        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            
            guard let response = response as? Moya.Response else{
                
                throw RxSwiftMoyaError.NoRepresentor
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.NotSuccessfulHTTP
            }
            
            //json shell
            let json = JSON.init(data: response.data)
            
            print("\(String(describing: json[RESULT_CODE].string))")
            print("\(String(describing: json[RESULT_MSG].string))")
            
            if json[RESULT_CODE].int == Int(RxSwiftMoyaError.IBSuccess.rawValue){
                
                guard let array = json.rawValue as? [Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                guard let dicts = array as? [[String: Any]] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                return Mapper<T>().mapArray(JSONArray: dicts)
                
            }else{
                
                throw MyErrorEnum.IBError(Code: json[RESULT_CODE].int!, Msg: json[RESULT_MSG].string!)
                
            }
            
        }
    }
    
    func mapAddList<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
        
            guard let response = response as? Moya.Response else{
                
                throw RxSwiftMoyaError.NoRepresentor
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.NotSuccessfulHTTP
            }
            
            let json = JSON.init(data: response.data)
            
            print("\(String(describing: json[RESULT_CODE].string))")
            print("\(String(describing: json[RESULT_MSG].string))")
            
            if json[RESULT_CODE].int == Int(RxSwiftMoyaError.IBSuccess.rawValue){
                
                guard let array = json.rawValue as? [Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                guard let dicts = array as? [[String: Any]] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                return Mapper<T>().mapArray(JSONArray: dicts)
                
            }else{
                
                throw MyErrorEnum.IBError(Code: json[RESULT_CODE].int!, Msg: json[RESULT_MSG].string!)
                
            }
            
        }
    }
    
    private func resultFromJSON<T: Mapable>(jsonData:JSON, classType: T.Type) -> T? {
        return T(jsonData: jsonData)
    }
    
}

enum RxSwiftMoyaError: String {
    case NoRepresentor = "请求出错"
    case ParseJSONError = "JSONError"
    case NotSuccessfulHTTP = "网络错误"
    case pramsError = "参数错误"
    case ServierError = "服务器错误"
    case IBSuccess = "100"
    case IBFromCodeStatus = "StatusCodeError"
}

extension RxSwiftMoyaError: Swift.Error {}
extension MyErrorEnum: Swift.Error {}

public enum MyErrorEnum {
    case IBError(Code:Int ,Msg:String)
    
    var drawCodeValue:Int{
        switch self {
        case .IBError(let code, _):
            return code
        }
    }
    
    var drawMsgValue:String{
        switch self {
        case .IBError(_, let msg):
            return msg
        }
    }
    
}
