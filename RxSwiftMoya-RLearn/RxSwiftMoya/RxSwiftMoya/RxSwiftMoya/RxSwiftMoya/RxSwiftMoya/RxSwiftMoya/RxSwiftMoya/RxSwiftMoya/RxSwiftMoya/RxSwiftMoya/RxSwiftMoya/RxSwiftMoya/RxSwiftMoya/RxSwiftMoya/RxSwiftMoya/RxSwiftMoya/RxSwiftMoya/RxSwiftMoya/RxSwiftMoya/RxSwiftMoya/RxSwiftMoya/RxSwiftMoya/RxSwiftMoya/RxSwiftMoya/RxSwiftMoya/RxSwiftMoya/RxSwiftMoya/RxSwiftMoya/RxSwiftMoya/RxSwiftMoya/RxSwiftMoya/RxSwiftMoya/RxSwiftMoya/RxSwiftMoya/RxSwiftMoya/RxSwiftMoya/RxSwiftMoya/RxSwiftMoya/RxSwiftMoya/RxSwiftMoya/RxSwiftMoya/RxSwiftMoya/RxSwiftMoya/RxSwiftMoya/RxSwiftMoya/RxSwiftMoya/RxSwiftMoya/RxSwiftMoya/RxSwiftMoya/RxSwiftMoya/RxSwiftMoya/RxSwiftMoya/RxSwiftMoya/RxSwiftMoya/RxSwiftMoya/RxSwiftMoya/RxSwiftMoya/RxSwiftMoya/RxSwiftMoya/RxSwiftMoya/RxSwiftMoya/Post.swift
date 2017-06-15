//
//  Post.swift
//  RxSwiftMoya
//
//  Created by Chao Li on 9/21/16.
//  Copyright © 2016 ERStone. All rights reserved.
//

import Foundation
import ObjectMapper

class Post: Mappable {
    var id: Int?
    var title: String?
    var body: String?
    var userId: Int?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        userId <- map["userId"]
    }
    
    public var description: String {
            return self.toJSONString()!
    }
    
}

class PostCV: Mappable {
    var message: String?
    var code: Int?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        code <- map["code"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}
