//
//  NormalShoppingCarVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/9.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import RxSwift
import ObjectMapper
import SwiftyJSON

class NormalShoppingCarVC: UIViewController,ShoppingCarHeaderDelegate,TCellMallCarDelegate {
    
    @IBOutlet weak var table_main: UITableView!
    
    @IBOutlet weak var label_totalprice: UILabel!
    
    @IBOutlet weak var bton_allchoose: UIButton!
    
    //network
    let OrderM = orderModel()
    let modelshoppingCarProductsPost = ModelShoppingCarProductsPost()
    let modelEditProductsPost = ModelShoppingCarProductEditPost()
    let disposeBag = DisposeBag()
    
    var viewhader:UIView! = nil
    
    var arrayMain = NSMutableArray()
    
    let DicSectionChoose = NSMutableDictionary()///记录各个店铺全选情况
    var flagAllChoose = false    ///记录所有店全选情况
    
    var TotalPrice:Int = 0{
        willSet{
            
        }
        didSet{
            let str = String(describing: TotalPrice)
            label_totalprice.text = String.init("¥ \(String(describing: str.fixPrice()))")
        }
    }
    
    var tableEmpty:Bool = false{
        
        willSet{
            
        }
        didSet{
            if tableEmpty == true {
                self.view.bringSubview(toFront: viewhader)
            }else{
                self.view.sendSubview(toBack: viewhader)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getDate()
        bton_allchoose.isSelected = false
        flagAllChoose = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bton_allchoose.setImage(UIImage.init(named: "choose_s"), for: .selected)
        
        setNavi()
        
        table_main.register(UINib.init(nibName: "TCellMallCar", bundle: nil), forCellReuseIdentifier: "TCellMallCar")
        
        table_main.backgroundColor = FlatWhiteLight
        
        table_main.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    func getDate() {
        
        modelshoppingCarProductsPost.userId = USERM.MemberID
        modelshoppingCarProductsPost.companyId = PARTNERID
        
        OrderM.shopShoppingCarProducts(amodel: modelshoppingCarProductsPost)
            .subscribe(onNext: { (result: ModelShoppingCarProductsResult) in
                
                
                self.arrayMain.removeAllObjects()
                
                if let array = result.data{
                    
                    self.arrayMain.addObjects(from: array)
                    
                    self.resetAllChooseData()
                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavi() {
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")

        self.navigationItem.leftBarButtonItem = item
        
        self.navigationItem.title = "我的购物车"
        
        viewhader = Bundle.main.loadNibNamed("viewMallHolder", owner: nil, options: nil)?.first as? viewMallHolder
        
        self.view.addSubview(viewhader!)
        
        viewhader?.snp.makeConstraints({ (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.width)
        })
        
        self.view.sendSubview(toBack: viewhader!)
        
    }
    
    func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAllChoose(_ sender: Any) {
        
        if bton_allchoose.isSelected {
            bton_allchoose.isSelected = false
            flagAllChoose = false
        }else{
            bton_allchoose.isSelected = true
            flagAllChoose = true
        }
        
        resetAllChooseData()
    }
    
    func resetAllChooseData(){
        
        for i in 0..<arrayMain.count {
            let products = arrayMain[i] as! ModelShoppingCarProducts
            DicSectionChoose.setValue(flagAllChoose, forKey: "section\(i)")
            
            for item in products.products! {
                item.chooseFlag = flagAllChoose
            }
        }
        
        self.table_main.reloadData()
        
        restBottomAllChoose()
        
        fixTotalPrice()
    }
    
    func restBottomAllChoose(){
        
        let array = DicSectionChoose.allValues as! [Bool]
        
        PrintFM("\(array)")
        
        let filterArrays = array.filterDuplicates({$0})
        
        PrintFM("\(filterArrays)")
        
        if filterArrays.count == 1 {
            bton_allchoose.isSelected = filterArrays[0]
            flagAllChoose = filterArrays[0]
        }else{
            bton_allchoose.isSelected = false
            flagAllChoose = false
        }
        
        fixTotalPrice()
        
    }
    
    func fixTotalPrice(){
        
        var totalPrice:Int = 0
        
        for i in 0..<arrayMain.count {
            let products = arrayMain[i] as! ModelShoppingCarProducts
            for item in products.products! {
                if item.chooseFlag == true{
                    totalPrice = totalPrice + (item.finalPrice! * item.productNumber!)
                }else{
                    continue
                }
            }
        }
        
        TotalPrice = totalPrice
        
    }
    func fixChoosedProducts()->NSMutableArray {
        
        let array_Choosed = NSMutableArray()
        
        for i in 0..<arrayMain.count {
            
            let array_products = NSMutableArray()
            
            let products = arrayMain[i] as! ModelShoppingCarProducts
            for item in products.products! {
                if item.chooseFlag == true{
                    array_products.add(item)
                }else{
                    continue
                }
            }
            
            if array_products.count != 0 {
                let shopModel = arrayMain[i] as! ModelShoppingCarProducts
                shopModel.products = array_products as? [ModelShopDetailItem]
                
                array_Choosed.add(shopModel)
                
            }
            
        }
        
        return array_Choosed
    }
    
    //MARK:前往支付
    @IBAction func action_PayNow(_ sender: Any) {
        
        let array = fixChoosedProducts()
        
        if array.count == 0 {
            HUDShowMsgQuick(msg: "请至少选择一个商品进行结算", toView: self.view, time: 0.8)
            return
        }
        
        let Vc = StoryBoard_ActivityPages.instantiateViewController(withIdentifier: "ShoppingCarPayVC") as! ShoppingCarPayVC
        
        Vc.arrayMain = array
        
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
}

extension NormalShoppingCarVC:UITableViewDataSource{
    
    //    店铺选择处理
    func setChooseValue(section:Int,sectionFlag:Bool){
        
        DicSectionChoose.setValue(sectionFlag, forKey: "section\(section)")
        
        //所有店铺内商品  优先级低于 店铺选择
        let products = arrayMain[section] as! ModelShoppingCarProducts
        for item in products.products ?? [] {
            item.chooseFlag = sectionFlag
        }
        
        restBottomAllChoose()
        
        self.table_main.reloadData()
        
    }
    
    func setAction(indexpath:IndexPath,actionType:ChooseCoverActionType){
        
        PrintFM("")
        
        let products = arrayMain[indexpath.section] as! ModelShoppingCarProducts
        
        var setNum = Int()
        
        if let product = products.products?[indexpath.row] {
            
            switch actionType {
            case .ADD:
                setNum = product.productNumber! + 1
            case .Fls:
                setNum = product.productNumber! - 1
            default:
                PrintFM("")
            }
            
            self.modelEditProductsPost.shoppingcartId = products.scid
            self.modelEditProductsPost.productid = product.pid
            self.modelEditProductsPost.number = setNum
            
            self.OrderM.shopShoppingCarSetProductNum(amodel: self.modelEditProductsPost)
                .subscribe(onNext: { (result: ModelShoppingCarAddResult) in
                    
                    product.productNumber = setNum
                    
                    self.fixTotalPrice()
                    
                },onError:{error in
                    
                    self.table_main.reloadRows(at: [indexpath], with: .fade)
                    
                    if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                        HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                    }else{
                        HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                    }
                })
                .addDisposableTo(self.disposeBag)
            
            
        }
        
        
    }
    
    //    商品选择处理
    func setChooseValue(indexpath:IndexPath,cellFlag:Bool){
        
        let products = arrayMain[indexpath.section] as! ModelShoppingCarProducts
        
        if let array = products.products{
            
            array[indexpath.row].chooseFlag = cellFlag
            
            let filterArrays = array.filterDuplicates({$0.chooseFlag!})
            
            if filterArrays.count == 1 {
                DicSectionChoose.setValue(filterArrays[0].chooseFlag, forKey: "section\(indexpath.section)")
            }else{
                DicSectionChoose.setValue(false, forKey: "section\(indexpath.section)")
            }
            
        }
        
        restBottomAllChoose()
        
        self.table_main.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let viewheader = Bundle.main.loadNibNamed("ViewMallCarHeader", owner: nil, options: nil)?.first as? ViewMallCarHeader
        
        viewheader?.delegate = self
        
        viewheader?.section = section
        
        viewheader?.bton_choose.isSelected = DicSectionChoose.value(forKey: "section\(section)") as! Bool
        
        //        PrintFM("\(DicSectionChoose)")
        
        let products = arrayMain[section] as! ModelShoppingCarProducts
        
        viewheader?.label_name.text = products.linkName ?? " "
        
        return viewheader
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = arrayMain.count
        
        tableEmpty = (count == 0)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let products = arrayMain[section] as! ModelShoppingCarProducts
        
        return (products.products?.count) ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellMallCar", for: indexPath) as! TCellMallCar
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.delegate = self
        
        cell.indexpath = indexPath
        
        let products = arrayMain[indexPath.section] as! ModelShoppingCarProducts
        
        if let product = products.products?[indexPath.row] {
            cell.setContent(product: product)
        }
        
        return cell
    }
    
}


extension NormalShoppingCarVC: UITableViewDelegate {
    
    func productDelete(indexPath:IndexPath) {
        
        let products = arrayMain[indexPath.section] as! ModelShoppingCarProducts
        
        let PList = NSMutableArray.init(array: products.products!)
        
        PList.remove(PList[indexPath.row])
        
        if PList.count == 0{
            self.arrayMain.removeObject(at: indexPath.section)
            self.table_main.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
        }else{
            products.products = PList as? [ModelShopDetailItem]
            self.table_main.deleteRows(at: [indexPath], with: .fade)
        }
        
        self.fixTotalPrice()
        HUDShowMsgQuick(msg: "删除成功", toView: self.view, time: 0.8)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "提示", message: "删除数据将不可恢复", preferredStyle: .alert)
            
            let calcelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "删除", style: .default, handler: { (UIAlertAction) in
                
                let products = self.arrayMain[indexPath.section] as! ModelShoppingCarProducts
                
                if let product = products.products?[indexPath.row] {
                    self.modelEditProductsPost.shoppingcartId = products.scid
                    self.modelEditProductsPost.productid = product.pid
                    self.modelEditProductsPost.number = product.productNumber
                }else{
                    return
                }
                
                self.OrderM.shopShoppingCarDeleteProduct(amodel: self.modelEditProductsPost)
                    .subscribe(onNext: { (result: ModelShoppingCarAddResult) in
                        
                        self.productDelete(indexPath: indexPath)
                        
                    },onError:{error in
                        if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                            HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                        }else{
                            HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                        }
                    })
                    .addDisposableTo(self.disposeBag)
            })
            
            // 添加
            alert.addAction(calcelAction)
            alert.addAction(deleteAction)
            
            // 弹出
            self.present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}

