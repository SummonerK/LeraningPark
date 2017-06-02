//
//  User+CoreDataProperties.swift
//  IBCoredata
//
//  Created by Luofei on 2017/6/2.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userID: Int16
    @NSManaged public var userEmail: String?
    @NSManaged public var userPwd: String?

}
