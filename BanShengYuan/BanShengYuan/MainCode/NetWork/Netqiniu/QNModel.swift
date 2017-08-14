//
//  QNModel.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/14.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Qiniu

let Token = "4or0KAuHNO8XcfGCr8el0EP-rVqwtQuaAmzjNfD2"

let QNProvider = RxMoyaProvider<QNAPI>(plugins:[loadingPlugin,logPlugin])

class QNModel {
    
    func UpLoad(amodel:ModelTestPost) -> Observable<ModelTestBack> {
        return QNProvider.request(.UpLoad(PostModel: amodel))
            .mapObject(type: ModelTestBack.self)
        
    }
    
    func uploadImageToQN(filePath:String){
        
//        let uploadOption = QNUploadOption.init(progressHandler: {
//            (key:String,percent: Float) in
//            PrintFM("\(key)----percent\(percent)")
//        } as! QNUpProgressHandler)
        
        QNM.shared?.putFile(filePath, key: "bsy_sub_0001", token: Token, complete: {(info,key,resp) in
            PrintFM("七牛云\(String(describing: info))")
        }, option: nil)
        
    }
    
}

class QNM{
    static let shared = QNUploadManager()
    // 重载并私有
    private init() {
        PrintFM("create 单例")
    }
}
