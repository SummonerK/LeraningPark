//
//  Datas.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import CoreLocation

let BSYPHONE = "BSYPHONE"
let BSYPWD = "BSYPWD"
let BSYUSERID = "BSYUSERID"
let BSYMEMBERID = "BSYMEMBERID"
let BSYNAME = "BSYNAME"
let BSYUSERTOKEN = "BSYUSERTOKEN"
let COMPANYNAME = "COMPANYNAME"

let USERM = UserManager.shared

let userDefault = UserDefaults.standard

typealias locationBack = (_ back:CLLocation) -> Void

typealias ImageBack = (_ localPath:String) -> Void

class UserManager: NSObject,CLLocationManagerDelegate{
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    var locationB:locationBack!
    
    var ImageB:ImageBack!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let theLoactions:NSArray = locations as NSArray
        let location:CLLocation = theLoactions.object(at: 0) as! CLLocation        
        PrintFM("++++++++++++\(location)")
//        manager.stopUpdatingLocation()
        USERM.locationB(location)
        
    }
    
    func getLocation(Location: @escaping locationBack){
        USERM.locationManager.requestAlwaysAuthorization()
        USERM.locationManager.delegate = self
        USERM.locationManager.allowsBackgroundLocationUpdates = true
        USERM.locationB = Location
        USERM.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        USERM.locationManager.distanceFilter = 1000.0
        USERM.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() -> Void {
        USERM.locationManager.stopUpdatingLocation()
    }
    
    /**
     * swift3.0 单例样式
     * 使用方法：let mark = SingelClass.shared
     */
    
    static let shared = UserManager()
    // 重载并私有
    private override init() {
        PrintFM("create 单例")
    }
    
    var mamearySize:String{
        
        return String(format: "%.2f MB", fileSizeOfCache())
    }
    
    func fileSizeOfCache()-> Float {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        PrintFM("Memary Path = \(String(describing: cachePath))")
        //缓存目录路径
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let mm:Float = Float(size)/1024/1024
        return mm
    }
    func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }
    var CompanyName: String {
        if let str = userDefault.value(forKey: COMPANYNAME) {
            print("----我取到了公司名")
            return str as! String
        }else {
            return ""
        }
    }
    var Phone:String{
        
        if let str = userDefault.value(forKey: BSYPHONE){
            return str as! String
        }else{
            return ""
        }
    }
    var Pwd:String{
        if let str = userDefault.value(forKey: BSYPWD){
            return str as! String
        }else{
            return ""
        }
    }
    var UserID:String{
        if let str = userDefault.value(forKey: BSYUSERID){
            return str as! String
        }else{
            return ""
        }
    }
    var UserName:String{
        if let str = userDefault.value(forKey: BSYNAME){
            return str as! String
        }else{
            return ""
        }
    }
    var MemberID:String{
        if let str = userDefault.value(forKey: BSYMEMBERID){
            return str as! String
        }else{
            return ""
        }
    }
    var MemberToken:String{
        if let str = userDefault.value(forKey: BSYUSERTOKEN){
            return str as! String
        }else{
            return ""
        }
    }
    
    func setCompanyName(companyName: String){
        print("----我添加了公司名\(companyName)")
        userDefault.set(companyName, forKey: COMPANYNAME)
    }
    
    func setPhone(phone:String){
        userDefault.set(phone, forKey: BSYPHONE)
    }
    
    func setPwd(pwd:String){
        userDefault.set(pwd, forKey: BSYPWD)
    }
    
    func setUserID(uid:String){
        userDefault.set(uid, forKey: BSYUSERID)
    }
    
    func setUserName(uid:String){
        userDefault.set(uid, forKey: BSYNAME)
    }
    
    func setMemberID(uid:String){
        userDefault.set(uid, forKey: BSYMEMBERID)
    }
    
    func setMemberTOKEN(token:String){
        userDefault.set(token, forKey: BSYUSERTOKEN)
    }
    
    func FmLogAppendTxt(fileUrl:URL,txt:String) {
        
        do {
            if !FileManager.default.fileExists(atPath: fileUrl.path) {
                print("---创建文件\(fileUrl.path)")
                FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
            }
            print("---\(fileUrl.path)")
            let fileHandle = try FileHandle(forWritingTo: fileUrl)
            let writeTxt = "\n\(txt)"
            //文末添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeTxt.data(using: String.Encoding.utf8)!)
        } catch let error as NSError {
            print("-----failed to append: \(error)")
        }
        
    }
    
    /**
     文件日志
     */
    func FmLog(message:String,file:String=#file,function:String=#function,line:Int=#line) {
        let fileName = (file as NSString).lastPathComponent
        //日志内容
        let consoleStr = "\(fileName):\(line) \(function) | \(message)"
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        // 为日期格式器设置格式字符串
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 使用日期格式器格式化当前日期、时间
        let datestr = dformatter.string(from: Date())
        //将内容同步写到文件中去（Caches文件夹下）
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        
        print("\(cachePath.path)");
        
        let logURL = cachePath.appendingPathComponent("Fmlog.txt")
        FmLogAppendTxt(fileUrl: logURL, txt: "\(datestr) \(consoleStr)")
    }
    
    func getCachePath() -> String{
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("Fmlog.txt")
        return logURL.path
    }
    
    func FmLogRead() -> String{
        //（Caches文件夹下）
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("Fmlog.txt")
        if !FileManager.default.fileExists(atPath: logURL.path) {
            FileManager.default.createFile(atPath: logURL.path, contents: nil, attributes: nil)
        }
        var result:Data?
        do{
            
            result = try Data(contentsOf: logURL, options: Data.ReadingOptions.uncached)
        }catch{
            return ""
        }
        return String(data: result!, encoding: .utf8)!
        
    }
    
}


/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}

extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    func toArrayJsonString() -> String{
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        return strJson! as String
    }
    
}

extension NSMutableArray{
    
    func toArrayJsonString() -> String{
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        return strJson! as String
    }

    
}

extension Int
{
    func hexedString() -> String
    {
        return NSString(format:"%02x", self) as String
    }
}

//对Data类型进行扩展
extension Data {
    //将Data转换为String
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}

