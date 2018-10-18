//
//  ListViewSetting.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/17.
//  Copyright © 2018年 FreeMud. All rights reserved.
//


import UIKit
import Foundation

private func configIdentifier(_ identifier: inout String) -> String {
    //        var index = identifier.index(of: ".")
    var index = identifier.characters.index(of: ".") ///查找字符位置，如果没查到则为nil
    guard index != nil else { return identifier }
    index = identifier.index(index!, offsetBy: 1)
    identifier = String(identifier[index! ..< identifier.endIndex])
    return identifier
}
///let cell = IBLCellWithTableView(tableView)
public func IBLCellWithTableView<T: UITableViewCell>(_ tableView: UITableView) -> T {
    var identifier = NSStringFromClass(T.self)
    identifier = configIdentifier(&identifier)
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
    if cell == nil {
        cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
    }
    return cell as! T
}

extension  UITableView{
    
    public func registerNibClassName(_ aClass:AnyClass) -> Void {
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
    /// registerCell(tableView, UITableViewCell.self)
    public func IBLRegisterCell( _ cellCls: AnyClass) {
        var identifier = NSStringFromClass(cellCls)
        identifier = configIdentifier(&identifier)
        self.register(cellCls, forCellReuseIdentifier: identifier)
        
    }
}

extension  UICollectionView{
    
    /// tv_main.registerNibName(TCellBleroot.self)

    public func IBLRegisterCell(_ cellCls:AnyClass){
        var identifier = NSStringFromClass(cellCls)
        identifier = configIdentifier(&identifier)
        self.register(cellCls, forCellWithReuseIdentifier: identifier)
    }
    
    public func registerNibClassName(_ aClass:AnyClass) -> Void {
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    
    public func registerNibClassNameWithId(_ aClass:AnyClass,_ name: String) -> Void {
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
    
    public func registerHeadNibClassName(_ aClass:AnyClass) -> Void {
        let  className = String(describing: aClass)
        let  nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier:className)
    }
    
    public func simpleReloadItem(index: Int) {
        self.performBatchUpdates({
            let indexSet = IndexSet.init(integer: index)
            self.reloadSections(indexSet)
        }, completion: nil)
    }
    
}



/*
 
 //public protocol IBLListViewProtocal{}
 //
 //public extension IBLListViewProtocal{
 //
 //    private func configIdentifier(_ identifier: inout String) -> String {
 ////        var index = identifier.index(of: ".")
 //        var index = identifier.characters.index(of: ".")
 //        guard index != nil else { return identifier }
 //        index = identifier.index(index!, offsetBy: 1)
 //        identifier = String(identifier[index! ..< identifier.endIndex])
 //        return identifier
 //    }
 //    ///let cell = IBLCellWithTableView(tableView)
 //    public func IBLCellWithTableView<T: UITableViewCell>(_ tableView: UITableView) -> T {
 //        var identifier = NSStringFromClass(T.self)
 //        identifier = configIdentifier(&identifier)
 //        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
 //        if cell == nil {
 //            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
 //        }
 //        return cell as! T
 //    }
 //
 //    /// registerCell(tableView, UITableViewCell.self)
 //    public func IBLRegisterCell(_ tableView: UITableView, _ cellCls: AnyClass) {
 //
 //        var identifier = NSStringFromClass(cellCls)
 //
 //        identifier = configIdentifier(&identifier)
 //
 //        tableView.register(cellCls, forCellReuseIdentifier: identifier)
 //        
 //    }
 //    
 //}
 
 public func tableViewConfig(_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableViewStyle?) -> UITableView  {
 let tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: style ?? .plain)
 tableView.delegate = delegate
 tableView.dataSource = dataSource
 return tableView
 }
 
 public func tableViewConfig(_ frame: CGRect ,_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableViewStyle?) -> UITableView  {
 let tableView = UITableView(frame: frame, style: style ?? .plain)
 tableView.delegate = delegate
 tableView.dataSource = dataSource
 return tableView
 }
 */
