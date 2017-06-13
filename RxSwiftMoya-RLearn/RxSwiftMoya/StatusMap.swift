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


public extension Observable {
    
    func showError() -> Observable<Element> {
        return self.doOn {event in
            switch event{
            case .error(let e):
                print("showError \(e)")
            default:
                print("default")
            }
        }
    }
}


