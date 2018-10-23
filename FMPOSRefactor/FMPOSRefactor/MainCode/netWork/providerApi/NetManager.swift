//
//  NetManager.swift
//  wms
//
//  Created by Luofei on 2018/4/11.
//  Copyright © 2018年 lf. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire
import ObjectMapper
import SwiftyJSON


let accountBasepath = "http://console.freemudvip.com"  //api
let itunesPath = "https://itunes.apple.com/cn/lookup?id=1435451924"  //api
//let payBasePath = "http://115.159.63.201:37216"
//let payBasePath = "http://115.159.119.32:26748"
let payBasePath = "https://proxy.sandload.cn"
let ImageUrlPath = ""
let ImageDownloadPath = ""

enum NETManager {
    case test(ParamModel:ModelLoadFile)//测试http
    case upLoadFile(ParamModel:ModelLoadFile)//测试http

}

extension NETManager: TargetType {
    
    var baseURL: URL {
        
        return URL(string: ImageUrlPath)!
        
    }
    
    var path: String {
        switch self {
        case .test(_):
            return ""
        case .upLoadFile(_):
            return "handler/ProcRequest.ashx"
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        PrintFM("parameterEncoding")
        switch self {
        case .upLoadFile:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upLoadFile:
            return .post
        default:
            return .get
        }
    }
    
    
    var parameters: [String: Any]? {
        switch self {
        case .test(let model):
            return model.DicValue
        case .upLoadFile(_):
            return nil
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "API successfully".data(using: .utf8)!
        }
        
    }
    
    // MARK: URLRequestConvertible
    //组织表单
    var task: Task {
        
        switch self {
        case .upLoadFile(let model):
            let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            
            let filePath: String = String(format: "%@/%@", cachePath!, model.key!)
            print("filePath:" + filePath)
            
            let fileData = try! Data(contentsOf: URL.init(fileURLWithPath: filePath))
            
            let data:Data = "UploadImage".data(using: .utf8)!
            
            let formData3 = MultipartFormData(provider: .data(fileData), name: "fileid",
                                              fileName: model.key!, mimeType: "image/png")
            let formData4 = MultipartFormData(provider: .data(data), name: "action")

            let multipartData = [formData3,formData4]
            return .upload(.multipart(multipartData))
            
        default:
            return .request
        }
        
    }
    
}

enum RxSwiftMoyaError: String {
    case NoRespons = "无响应数据"
    case ParseJSONError = "数据解析错误"
    case OtherError
    case NoDataError = "数据为空"
    case NetWorkError = "网络错误"
    case OurResponseError
}
extension RxSwiftMoyaError: Swift.Error {
    
    func ErrorBack(){
        HUDShowMsgQuick(self.rawValue, 0.8)
    }
    
}
extension Observable {
    
    func catchErrorJustReturn(_ element: Element) -> Observable<Element> {
        
        PrintFM("\(element)")
        
        return element as! Observable<Element>
    }
}

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let result = response as? Moya.Response else {
                
                throw RxSwiftMoyaError.NoRespons
            }
            
            // check http status
            guard ((200...209) ~= result.statusCode) else {
                
                throw RxSwiftMoyaError.NetWorkError
            }
            
            let jsonObj = JSON.init(data: result.data)
            
            // check 服务器返回 status
            
            guard let dict = jsonObj.rawValue as? [String:Any] else{
                throw RxSwiftMoyaError.ParseJSONError
            }
            
//            print("---row值\(dict)")
            let results =  Mapper<T>().map(JSON: dict)!
            
            return results
        }
    }
    
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let result = response as? Moya.Response else {
                throw RxSwiftMoyaError.NoRespons
            }
            
            // check http status
            guard ((200...209) ~= result.statusCode) else {
                throw RxSwiftMoyaError.NetWorkError
            }
            
            
            let json = JSON.init(data: result.data)
            print("---\(json)")
            // check 服务器返回 status
            guard let array = json.rawValue as? [Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
                
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
                
            return Mapper<T>().mapArray(JSONArray: dicts)
            
        }
    }
}









