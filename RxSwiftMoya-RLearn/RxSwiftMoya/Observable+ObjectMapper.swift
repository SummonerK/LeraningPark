//
//  Observable+ObjectMapper.swift
//  RxSwiftMoya
//
//  Created by Chao Li on 9/20/16.
//  Copyright © 2016 ERStone. All rights reserved.
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

let RESULT_CODE = "code"  //约定的code格式
let RESULT_MSG = "message"     //约定的msg格式

/*
 {
 "resultCode":200,
 "resultMsg":"查询成功!",
 "data":{
 "city":"北京",
 "temperature":"8℃~20℃",
 "weather":"晴转霾"
 }
 }
 */

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            // check http status
            guard let response = response as? Moya.Response else{
                throw RxSwiftMoyaError.NoRepresentor
            }
            guard ((200...209) ~= response.statusCode) else {
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
                
                throw MyErrorEnum.IBError(resultCode: json[RESULT_CODE].int, resultMsg: json[RESULT_MSG].string)
                
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
                
                return Mapper<T>().mapArray(JSONArray: dicts)!
                
            }else{
                
                throw MyErrorEnum.IBError(resultCode: json[RESULT_CODE].int, resultMsg: json[RESULT_MSG].string)
                
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
    case IBSuccess = "200"
    case IBFromCodeStatus = "StatusCodeError"
}

extension RxSwiftMoyaError: Swift.Error {
    
}


public enum MyErrorEnum : Swift.Error {
    case IBError(resultCode:Int? ,resultMsg:String?)
}

