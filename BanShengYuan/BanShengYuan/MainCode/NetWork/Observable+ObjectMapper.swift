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

let PartNerID = "a8bee0dd-09d1-4fa9-a9eb-80cb36d3d611"

public protocol Mapable {
    init?(jsonData:JSON)
}

let RESULT_CODE = "statusCode"  //约定的code格式
let RESULT_MSG = "msg"     //约定的msg格式

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            // check http status
            guard let response = response as? Moya.Response else{
                throw MyErrorEnum.HttpError(Code: 1002, Msg: "请求出错")
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw MyErrorEnum.HttpError(Code: response.statusCode, Msg: "HttpError")
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
                throw MyErrorEnum.HttpError(Code: 1002, Msg: "请求出错")
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw MyErrorEnum.HttpError(Code: response.statusCode, Msg: "HttpError")
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
                throw MyErrorEnum.HttpError(Code: 1002, Msg: "请求出错")
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw MyErrorEnum.HttpError(Code: response.statusCode, Msg: "HttpError")
            }
            
            let json = JSON.init(data: response.data)
            
            print("\(String(describing: json[RESULT_CODE].string))")
            print("\(String(describing: json[RESULT_MSG].string))")
            
            if json[RESULT_CODE].int == Int(RxSwiftMoyaError.IBSuccess.rawValue){
                
                guard let array = json["deliverAddList"].rawValue as? [Any] else {
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
    
    
    
    func mapshopList<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            
            guard let response = response as? Moya.Response else{
                throw MyErrorEnum.HttpError(Code: 1002, Msg: "请求出错")
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw MyErrorEnum.HttpError(Code: response.statusCode, Msg: "HttpError")
            }
            
            let json = JSON.init(data: response.data)
            
            print("\(String(describing: json["errcode"].string))")
            print("\(String(describing: json["errmsg"].string))")
            
            if json["errcode"].int == Int(RxSwiftMoyaError.IBVIPSuccess.rawValue){
                
                guard let data = json["data"].rawValue as? [String: Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                guard let array = data["list"] as? [Any] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                guard let dicts = array as? [[String: Any]] else {
                    throw RxSwiftMoyaError.ParseJSONError
                }
                
                return Mapper<T>().mapArray(JSONArray: dicts)
                
            }else{
                
                throw MyErrorEnum.IBError(Code: json["errcode"].int!, Msg: json["errmsg"].string!)
                
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
    
    case IBVIPSuccess = "0"
}

extension RxSwiftMoyaError: Swift.Error {}
extension MyErrorEnum: Swift.Error {}

public enum MyErrorEnum {
    case HttpError(Code:Int ,Msg:String)
    case IBError(Code:Int ,Msg:String)
    
    var drawCodeValue:Int{
        switch self {
        case .IBError(let code, _):
            return code
        case .HttpError(let code, _):
            return code
        }
    }
    
    var drawMsgValue:String{
        switch self {
        case .IBError(_, let msg):
            return msg
        case .HttpError(_, let msg):
            return msg
        }
    }
    
}

var mAllRequestCount = 0

let loadingPlugin = NetworkActivityPlugin { (change) -> () in
    
    switch(change){
    case .began:
        mAllRequestCount += 1
//        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        mAllRequestCount -= 1
        if mAllRequestCount == 0 {
//            SVProgressHUD.dismiss()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
}

let logPlugin = NetworkLoggerPlugin.init(verbose: true, cURL: true, output: {(_ separator: String, _ terminator: String, _ items: Any...) in
    for item in items{
        print("---\(item)")
        
    }
    
}, responseDataFormatter: nil)
