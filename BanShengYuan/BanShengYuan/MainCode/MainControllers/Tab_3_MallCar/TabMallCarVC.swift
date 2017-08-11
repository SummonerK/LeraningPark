//
//  TabMallCarVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/8/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import RxSwift
import ObjectMapper
import SwiftyJSON

class TabMallCarVC: UIViewController,ShoppingCarHeaderDelegate,TCellMallCarDelegate {

    @IBOutlet weak var table_main: UITableView!
    
    @IBOutlet weak var label_totalprice: UILabel!
    
    @IBOutlet weak var bton_allchoose: UIButton!
    
    //network
    let OrderM = orderModel()
    let modelshoppingCarProductsPost = ModelShoppingCarProductsPost()
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
    
//    table判空
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
        
        getDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bton_allchoose.setImage(UIImage.init(named: "choose_s"), for: .selected)

        setNavi()
        
        table_main.register(UINib.init(nibName: "TCellMallCar", bundle: nil), forCellReuseIdentifier: "TCellMallCar")
        
        table_main.backgroundColor = FlatWhiteLight
        
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

        self.navigationItem.title = "我的购物车"
        
//        empty holderView
        
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
        
        if arrayMain.count>0{
            for i in 0...arrayMain.count-1 {
                let products = arrayMain[i] as! ModelShoppingCarProducts
                DicSectionChoose.setValue(flagAllChoose, forKey: "section\(i)")
                
                for item in products.products! {
                    item.chooseFlag = flagAllChoose
                }
            }
            
            self.table_main.reloadData()
            
            fixTotalPrice()
        }
    }
    
    func restBottomAllChoose(){

        let array = DicSectionChoose.allValues as! [Bool]
        
        PrintFM("\(array)")
        
        let filterArrays = array.filterDuplicates({$0})
        
        PrintFM("\(filterArrays)")
        
        if filterArrays.count == 1 {
            bton_allchoose.isSelected = filterArrays[0]
        }else{
            bton_allchoose.isSelected = false
        }
        
        fixTotalPrice()
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
    
    func fixTotalPrice(){
        
        var totalPrice:Int = 0
        
        
        if arrayMain.count>0{
            for i in 0...arrayMain.count-1 {
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
        
    }
    
    func fixChoosedProducts()->NSMutableArray {
        
        let array_Choosed = NSMutableArray()
        
        if arrayMain.count > 0{
            
            for i in 0...arrayMain.count-1 {
                
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
                    let shopModel = (arrayMain[i] as! ModelShoppingCarProducts).copy()
                    
                    shopModel.products = array_products as? [ModelShopDetailItem]
                    
                    array_Choosed.add(shopModel)
                    
                }
                
            }
            
        }
        
        return array_Choosed
        
    }

}

extension TabMallCarVC:UITableViewDataSource{
    
//    店铺选择处理
    func setChooseValue(section:Int,sectionFlag:Bool){
        
        DicSectionChoose.setValue(sectionFlag, forKey: "section\(section)")
        
        //所有店铺内商品  优先级低于 店铺选择
        let products = arrayMain[section] as! ModelShoppingCarProducts
        for item in products.products! {
            item.chooseFlag = sectionFlag
        }
        
        restBottomAllChoose()
        
        self.table_main.reloadData()
        
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
        
        return viewheader
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = arrayMain.count
        
        tableEmpty = (count == 0)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let products = arrayMain[section] as! ModelShoppingCarProducts
        
        return (products.products?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellMallCar", for: indexPath) as! TCellMallCar
        
        cell.delegate = self
        
        cell.indexpath = indexPath
        
        let products = arrayMain[indexPath.section] as! ModelShoppingCarProducts
        
        if let product = products.products?[indexPath.row] {
            cell.setContent(product: product)
        }
        
        return cell
    }
    
}


extension TabMallCarVC: UITableViewDelegate {
    
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


