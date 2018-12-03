//
//  IBLFileManager.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/23.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import Foundation
import CoreData

/// MARK:封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("【☆☆】\(fileName)\t【☆】func:\(function)\t【☆】ATLine:\(line)\n【☆】LOG:\(message)")
    #endif
}


let IBLFileM = IBLFileManager.shared

class IBLFileManager: NSObject {
    
    var context: NSManagedObjectContext?
    let app = (UIApplication.shared.delegate as! AppDelegate)
    let entityName = "IBLLOrder"
    let productName = "IBLLProduct"
    
    lazy var IBLContext : NSManagedObjectContext = {
        
        var myContext : NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        
        return myContext
        
    }()
    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    
    static let shared = IBLFileManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    //TODO: 全表操作 封装
    
    func savetext(_ orderid:String ,_ date:Date,_ data:Data,_ dataString:String,_ type:IBL_WM_DBTYPE) -> Void {
        var myContext : NSManagedObjectContext!;
        
        PrintFM("\(orderid)\n\(data)\n\(dataString)")
        
//        if #available(iOS 10.0, *) {
//            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
        
        let onePerson = NSEntityDescription.insertNewObject(forEntityName: entityName, into: IBLContext) as! IBLLOrder
        
        onePerson.orderUpdateTime = date as NSDate
        onePerson.orderId = orderid
        
        app.saveContext()
    }
    
    
    //TODO: 全表操作 封装
    
    func save(_ orderid:String ,_ date:Date,_ type:IBL_WM_DBTYPE) -> Void {
//        var myContext : NSManagedObjectContext!;
//        
//        if #available(iOS 10.0, *) {
//            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
        
        let oneOrder = NSEntityDescription.insertNewObject(forEntityName: entityName, into: IBLContext) as! IBLLOrder

        oneOrder.orderUpdateTime = date as NSDate
        oneOrder.orderId = orderid
        oneOrder.records = ["我就是评分表"]
        
//        let onePruduct = NSEntityDescription.insertNewObject(forEntityName: productName, into: myContext) as! IBLLProduct
//        onePruduct.pid = "12121212"
//        onePruduct.productName = "fm T恤"
        
        let onePruduct = NSEntityDescription.insertNewObject(forEntityName: productName, into: IBLContext) as! IBLLProduct
        
        onePruduct.pid = "12121214"
        onePruduct.productName = "fm T恤"
        
        let twoPruduct = NSEntityDescription.insertNewObject(forEntityName: productName, into: IBLContext) as! IBLLProduct
        
        twoPruduct.pid = "000002"
        twoPruduct.productName = "fm T恤1"
        
        oneOrder.proClass?.addingObjects(from: [onePruduct,twoPruduct])
        
//        oneOrder.proClass?.addingObjects(from: [onePruduct])
        
        onePruduct.orderClass = oneOrder
        twoPruduct.orderClass = oneOrder
        
        app.saveContext()
    }
    
    func update(_ orderid:String ,_ date:Date,_ type:IBL_WM_DBTYPE) -> Void {
        var myContext : NSManagedObjectContext!;
        
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: IBLContext)
        fetchRequest.entity = entity
        
        do {
            
            let resultList = try IBLContext.fetch(fetchRequest) as! [IBLLOrder]
            
            for user in resultList{
                
                //改
                if user.orderId == orderid{
                    //如果所有数据都同化，表中只存一
//                    user.updateTime = date as NSDate
                    user.orderUpdateTime = date as NSDate
                    
                    PrintFM("\(user)")
                    
                    let pros = user.proClass?.allObjects as! [IBLLProduct]
                    
                    for pro in pros{
//                        pro.pid
                        
                        pro.productName = "fm 卫衣"
                        
                        print("\(pro.pid)==\(pro.productName)")
                        
                        PrintFM("\(pro)")
                        
                    }
                    
                }

            }
            
//            print("result = \(resultList)")
        } catch let error {
            print("context can't fetch!, Error:\(error)")
        }
        
        app.saveContext()
        
    }
    
    func getdate(_ orderid:String) -> [IBLLOrder] {
        var myContext : NSManagedObjectContext!;
        
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        //  let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        /// 创建一个获取数据的实例，用来查询实体。
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        /// 创建规则
        let nameDescriptor = NSSortDescriptor(key: "orderId", ascending: true)
        let dateDescriptor = NSSortDescriptor(key: "orderUpdateTime", ascending: true)
        fetchRequest.sortDescriptors = [nameDescriptor,dateDescriptor]
        
//        let array = NSArray()
//        
//        _ = array.sortedArray(using: [nameDescriptor,dateDescriptor])
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: IBLContext)
        fetchRequest.entity = entity
        
        var result = [IBLLOrder]()
        
        var resultPro = [IBLLProduct]()
        
        do {
            
            let resultList = try myContext.fetch(fetchRequest) as! [IBLLOrder]
            
            for user in resultList{
                
                //查
                if user.orderId == orderid{
                    result.append(user)
                    
                    PrintFM("\(user)")
                    
                    PrintFM("\(user.records)")
                    
                    var proList = user.proClass?.allObjects as! [IBLLProduct]
                    
//                    PrintFM("\(proList)")
                    
                    for item in proList{
                        resultPro.append(item)
                    }
                    
                    
//                    for item in proList{
//                        print("\(item.pid)==\(item.productName)")
//                    }
//                    
//                    proList = proList.sort(withvalues: [("pid",true)])
//                    
//                    PrintFM("排序之后: \(proList)")
//                    
//                    for item in proList{
//                        print("\(item.pid)==\(item.productName)")
//                    }
                    
                }
            }
        } catch let error {
            print("context can't fetch!, Error:\(error)")
        }
        
        
//        for item in resultPro{
//            print("\(item.pid)==\(item.productName)==\(item.price)")
//        }
//
//        resultPro = resultPro.sort(withvalues: [("pid",true),("productName",true)])
//
//        PrintFM("排序之后: \(resultPro)")
//
//        for item in resultPro{
//            print("\(item.pid)==\(item.productName)==\(item.price)")
//        }
        
        return result
    }

    /// 全表操作
    /// 目前只针对 数据表IBLLOrder 做相关操作
    ///
    /// - Parameters:
    ///     - allType : ALL_DELETE 与 ALL_SAVE 配合使用 才能真正删除成功 【避免误删情况】
    ///
    func fileAllData(_ allType:IBL_ALL_DBTYPE) -> [IBLLOrder]{
        var myContext : NSManagedObjectContext!;
        
        if #available(iOS 10.0, *) {
            myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            myContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
//        fetchRequest.fetchLimit = 10
//        fetchRequest.fetchOffset = 0
        let dateDescriptor = NSSortDescriptor.init(key: "updateTime", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: myContext)
        fetchRequest.entity = entity
        
        var dataSource = [IBLLOrder]()
        
        do{
            let fetchedObjects = try myContext.fetch(fetchRequest) as! [IBLLOrder]
            dataSource = fetchedObjects
            
        }catch{
            print("get_coredata_fail!")
        }
        
        switch allType {
        case .ALL_READ:
            return dataSource
        case .ALL_DELETE:
            for user in dataSource{
                myContext.delete(user)
            }
            return []
        case .ALL_SAVE:
            app.saveContext()
            return []
        }
        
    }

}

extension Array{
    func sort(withvalues:[(String,Bool)]) -> Array {
        let sortArray = NSArray.init(array: self)
        
        var sortDes = [NSSortDescriptor]()
        
        for item in withvalues {
            let aDescriptor = NSSortDescriptor(key: item.0, ascending: item.1)
            sortDes.append(aDescriptor)
        }
        
        let result = sortArray.sortedArray(using: sortDes)
        
        return result as! Array<Element>
        
    }
}

enum IBL_WM_DBTYPE {
    case WM_SUCCESS          //成功
    case WM_FAILTURE         //失败
}

enum IBL_ALL_DBTYPE {
    case ALL_READ         //全表读取
    case ALL_DELETE       //全表删除
    case ALL_SAVE         //保存操作
}

extension IBL_WM_DBTYPE{
    var IBLDescription:String{
        switch self{
        case .WM_SUCCESS:
            return "记录状态-成功"
        case .WM_FAILTURE:
            return "记录状态-失败"
        }
    }
}


//TODO:- 订单内 商品进行排序 
/// 研究结果：数组可以操作多属性排序，
/// 因此，不需额外建立订单表。不同商户只需方法适配即可。
/// 创建规则
/*
 
//同时指定多个规则: 按name升序排列, 相同的再按score升序排列:
let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
let scoreDescriptor = NSSortDescriptor(key: "score", ascending: true)
let array = NSArray()
_ = array.sortedArray(using: [nameDescriptor,scoreDescriptor])

*/


































