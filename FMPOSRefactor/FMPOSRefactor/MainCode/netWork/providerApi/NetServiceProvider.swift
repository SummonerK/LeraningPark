//
//  NetServiceProvider.swift
//  wms
//
//  Created by 舒圆波 on 18/4/13.
//  Copyright © 2018年 lf. All rights reserved.
//

import Foundation
import Moya
import RxSwift

import SVProgressHUD

//MARK: provider


let AccountApiProvider = RxMoyaProvider<AccountApi>(plugins:[loadingPlugin,logPlugin])
let PayApiProvider = RxMoyaProvider<PayApi>(plugins:[loadingPlugin,logPlugin])

let arrayReqeustClosure = { (target: AccountApi) -> Endpoint<AccountApi> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    var tar = target.parameters
    print("---\(String(describing: tar))")
    if tar == nil {
        tar = ["key":"value"]
    }
    let targetParam = NSDictionary.init(dictionary: tar!)

    print("---转化后\(String(describing: tar))")
    let endpoint = Endpoint<AccountApi>(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
    return endpoint
}

let logPlugin = NetworkLoggerPlugin.init(verbose: true, cURL: true, output: {(_ separator: String, _ terminator: String, _ items: Any...) in
    for item in items{
        
        print("---\((item as! String).replacingOccurrences(of: "\\", with: ""))")
        
    }
    
    }, responseDataFormatter: nil)

let GlobalDisposeBag = DisposeBag()




var mAllRequestCount = 0

let loadingPlugin = NetworkActivityPlugin { (change) -> () in
    
    switch(change){
        
    case .began:
        
        mAllRequestCount += 1
        
        if mAllRequestCount == 1{
            
        }
        
        print("☆☆【☆】mAllRequestCount ++++++ = \(mAllRequestCount)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    case .ended:
        
        mAllRequestCount -= 1
        
        print("☆☆【☆】mAllRequestCount ----- = \(mAllRequestCount)")
        
        if mAllRequestCount == 0 {
            
            SVProgressHUD.dismiss(withDelay: 0.2)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
}
