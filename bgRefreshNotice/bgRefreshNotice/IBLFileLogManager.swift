//
//  IBLFileLogManager.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2019/1/7.
//  Copyright © 2019年 FreeMud. All rights reserved.
//

import UIKit

let IBLFileLogM = IBLFileLogManager.shared

///日志类型划分
enum LocalLogType {
    case IBLOG_TPYE_WM  ///外卖日志
    case IBLOG_TPYE_PAY ///支付日志
    case IBLOG_TPYE_COU ///券码日志
}

extension Date{
    
    func string_from(formatter: String?) -> String {
        
        if let format = formatter {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "zh_CN")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            let date_str = dateFormatter.string(from: self)
            return date_str
        }
        return ""
    }
    
}


///日志目录【门店号】>【日志日期】>【日志】

class IBLFileLogManager: NSObject {
    
    static let shared = IBLFileLogManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    func IBlogPath(type:LocalLogType) -> URL? {
        
        let storeId = "Lofi"
        
        let dateName = Date().string_from(formatter: "yyyy_MM_dd")
        
        //将内容同步写到文件中去（Caches文件夹下）documentDirectory
        let cachePath = FileManager.default.urls(for: .cachesDirectory,in: .userDomainMask)[0]
        
        let logURL = cachePath.appendingPathComponent("Store_\(storeId)")
        
        let logDateURL = logURL.appendingPathComponent("\(dateName)")
        
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        let existed = FileManager.default.fileExists(atPath: logDateURL.path)
        
        // 如果文件夹路径不存在，那么先创建文件夹
        if !existed {
            try! FileManager.default.createDirectory(at: logDateURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        var URLValue:URL!
        
        switch type {
        case .IBLOG_TPYE_WM:
            URLValue = logDateURL.appendingPathComponent("LOG_WM.txt")
        case .IBLOG_TPYE_PAY:
            URLValue = logDateURL.appendingPathComponent("LOG_PAY.txt")
        case .IBLOG_TPYE_COU:
            URLValue = logDateURL.appendingPathComponent("LOG_COU.txt")
        }
        
//        PrintFM("\(URLValue.path)")
        
        return URLValue
    }
    
    /**日志-日志内容外接*/
    func IBLogAppend(fromData:String,type:LocalLogType) -> Void {
        
        guard let valueUrl = IBlogPath(type: type) else {
            return
        }
        
        let valueString = String.init(format: "%@ >>>%@", Date().string_from(formatter: "HH:mm:ss"),fromData)
        
        appendText(fileUrl: valueUrl, value: valueString)
        
    }
    
    /**日志-内容添加*/
    fileprivate func appendText(fileUrl:URL,value:String) -> Void {
        do {
            //如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil)
            }
            let fileHandle = try FileHandle(forWritingTo: fileUrl)
            let stringToWrite =  value + "\n"
            
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
            
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
    
    /**移除相关日期的日志*/
    fileprivate func IBFileRemove(date:Date) -> Void {
        
        let storeId = "Lofi"
        
        let dateName = date.string_from(formatter: "yyyy_MM_dd")
        
        let fileManager = FileManager.default
        let cachePath = FileManager.default.urls(for: .cachesDirectory,in: .userDomainMask)[0]
        
        let logURL = cachePath.appendingPathComponent("Store_\(storeId)")
        let logDateURL = logURL.appendingPathComponent("\(dateName)")
        
        try! fileManager.removeItem(atPath: logDateURL.path)
    }

}
