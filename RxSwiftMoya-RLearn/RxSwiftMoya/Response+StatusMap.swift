//
//  Response+StatusMap.swift
//  RxSwiftMoya
//
//  Created by Luofei on 2017/6/5.
//  Copyright © 2017年 ERStone. All rights reserved.
//

import UIKit
import Moya
import RxSwift

enum StaticString {
    case failConextNet
    case failWithNoData
}

public extension ObservableType where E == Response{
    
    public func filterStatus() -> Observable<E>{
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.responseStatus())
        }
        
    }
    
}

extension Response{
    
    func responseStatus()throws -> Response{
        
        print("检测到 response status \(statusCode)")
        
//        switch statusCode {
//        case 200:
//            return self
//        case 404:
//            return 
//        default:
//            return self
//        }
        
        return self
        
    }
    
    
    
}
