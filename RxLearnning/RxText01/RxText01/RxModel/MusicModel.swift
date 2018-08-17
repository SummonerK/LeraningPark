//
//  MusicModel.swift
//  RxText01
//
//  Created by Luofei on 2018/8/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import RxSwift

func AnyColor(alpha:CGFloat)->UIColor{
    let anycolor = UIColor.init(hue: (CGFloat(Float(arc4random()%256) / 256.0)), saturation: (CGFloat(Float(arc4random()%256) / 256.0)), brightness: (CGFloat(Float(arc4random()%256) / 256.0)), alpha: alpha)
    return anycolor
}

struct Music {
    let name:String // 歌名
    let singer:String // 演唱者
    
    init(_ name:String,_ singer:String) {
        self.name = name
        self.singer = singer
    }
}

//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible{
    var description:String{
        return "name:\(name) singer:\(singer)"
    }
}

//歌曲列表数据源
struct MusicListViewModel {
//    let data = [
//        Music("无条件","陈奕迅"),
//        Music("你曾是少年", "S.H.E"),
//        Music("从前的我", "陈洁仪"),
//        Music("在木星", "朴树"),
//        ]
    
    let data = Observable.just([
        Music("无条件","陈奕迅"),
        Music("你曾是少年", "S.H.E"),
        Music("从前的我", "陈洁仪"),
        Music("在木星", "朴树"),
        ])
}
