//
//  ModelOrder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import ObjectMapper

//MARK:批量创建订单 postmodel

class ModelOrdersCreatePost:Mappable {
    var orders:[ModelOrderCreatePost]?           //商品集合
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        orders <- map["orders"]
    }
}

//MARK:批量创建订单 返回model

class ModelOrdersCreateBack:Mappable {
    var data:[String]?
    var errcode:String?
    var errmsg:String?
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
    }
}

//MARK:创建订单 postmodel

class ModelOrderCreatePost: Mappable {
    var companyId:String?           //partnerId
    var shopId:String?              //partnerId_storeid
    var shopName:String?          //门店名
    var userId:String?              //用户id
    var userName:String?          //用户名
    var phone:String?           //电话
    var address:String?        //地址
    var longitude:String?
    var latitude:String?
    var type:Int?                   //1外卖 2预订单 3商城 4自提 5堂吃
    var status:Int?             //1未支付 2已支付 3已退款 4部分退款 5线下支付 6支付中
    var amount:Int?             //支付金额
    var payType:Int?                //1线上支付 2货到付款
    var payChannel:String?          //支付渠道编号
    var payChannelName:String?      //支付渠道名称
    var source:String?              //“APP”
    var partition:String?           //拆单信息
    var customerOrder:String?       //第三方编号
    var remark:String?              //订单备注
    var products:[OrderProductItemReq]?     //订单商品
    var accounts:[OrderAccountItemReq]?     //积分 优惠 运费 包装等
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    
    func mapping(map: Map) {
        
        companyId <- map["companyId"]
        shopId <- map["shopId"]
        shopName <- map["shopName"]
        userId <- map["userId"]
        userName <- map["userName"]
        phone <- map["phone"]
        address <- map["address"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        type <- map["type"]
        status <- map["status"]
        amount <- map["amount"]
        payType <- map["payType"]
        payChannel <- map["payChannel"]
        payChannelName <- map["payChannelName"]
        source <- map["source"]
        partition <- map["partition"]
        customerOrder <- map["customerOrder"]
        remark <- map["remark"]
        products <- map["products"]
        accounts <- map["accounts"]
        
    }
    
}


class OrderProductItemReq:Mappable {
    var productId:String?           //商品id
    var productName:String?         //商品名字
    var number:Int?              //商品数量
    var specification:String?       //单位
    var price:Int?               //价格
    var sequence:String?            //排序
    
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    
    func mapping(map: Map) {
        productId <- map["productId"]
        productName <- map["productName"]
        number <- map["number"]
        specification <- map["specification"]
        price <- map["price"]
        sequence <- map["sequence"]
    }
}

class OrderAccountItemReq:Mappable {
    
    var accountId:String?       //结算id 优惠券id 没id的给0
    var name:String?            //积分 优惠券名
    var type:String?            // 1 运费 2折扣 3包装费
    var price:Int?           //结算价格 + -
    var number:String?          //结算数量
    var sequence:Int?           //排序
    
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    
    func mapping(map: Map) {
        accountId <- map["accountId"]
        name <- map["name"]
        type <- map["type"]
        price <- map["price"]
        number <- map["number"]
        sequence <- map["sequence"]
    }
}


//MARK:创建订单返回 backModel

class ModelOrderCreateBack: Mappable {
    
    var data: ModelOrderCreateBackItem?
    var errcode: String?
    var errmsg: String?
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelOrderCreateBackItem: Mappable {
    var address: String?
    var amount: String?
    var barCounter: String?
    var cancelReason: String?
    var companyId: String?
    
    var createUser: String?
    var customerOrder: String?
    var evaluateStatus: String?
    var gmtAccept: String?
    var gmtCreate: String?
    
    var gmtModified: String?
    var gmtPay: String?
    var latitude: String?
    var longitude: String?
    var oid: Int?                ///订单号
    
    var partition: String?
    var payChannel: String?
    var payChannelName: String?
    var payStatus: String?
    var payType: String?
    
    var payVoucher: String?
    var phone: String?
    var posId: String?
    var remark: String?
    var shopId: String?
    
    var shopName: String?
    var source: String?
    var sourceName: String?
    var status: String?
    var type: String?
    
    var userId: String?
    var userName: String?
    var userType: String?
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        address <- map["address"]
        amount <- map["amount"]
        barCounter <- map["barCounter"]
        cancelReason <- map["cancelReason"]
        companyId <- map["companyId"]
        
        createUser <- map["createUser"]
        customerOrder <- map["customerOrder"]
        evaluateStatus <- map["evaluateStatus"]
        gmtAccept <- map["gmtAccept"]
        gmtCreate <- map["gmtCreate"]
        
        gmtModified <- map["gmtModified"]
        gmtPay <- map["gmtPay"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        oid <- map["oid"]
        
        partition <- map["partition"]
        payChannel <- map["payChannel"]
        payChannelName <- map["payChannelName"]
        payStatus <- map["payStatus"]
        payType <- map["payType"]
        
        payVoucher <- map["payVoucher"]
        phone <- map["phone"]
        posId <- map["posId"]
        remark <- map["remark"]
        shopId <- map["shopId"]
        
        shopName <- map["shopName"]
        source <- map["source"]
        sourceName <- map["sourceName"]
        status <- map["status"]
        type <- map["type"]
        
        userId <- map["userId"]
        userName <- map["userName"]
        userType <- map["userType"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:批量支付订单 postmodel

class ModelOrdersPayPost:Mappable {
    var orders:[ModelOrderlistPayPost]?     //商品订单集合
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        orders <- map["orders"]
    }
}

//MARK:订单支付 postmodel
class ModelOrderlistPayPost:Mappable {
    var orderId:String!
    var pay_ebcode:String!
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        orderId <- map["orderId"]
        pay_ebcode <- map["pay_ebcode"]
    }
}

//MARK:订单支付 postmodel

class ModelOrderPayPost: Reflect {
    /**
     *  订单ID
     *  必传:True
     */
    var orderId:String!
    /**
     *  支付渠道编码
     *  必传:True 
     */
    var pay_ebcode:String!
    
}

//MARK:订单支付 backModel

class modelPayPlanBack:Mappable {
    var errcode:String?
    var errmsg:String?
    var data:ModelorderPay?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
        data <- map["data"]
    }
    
}

class ModelorderPay: Mappable {
    var actInfo: String?//支付状态码
    var biz_content: String?//支付账户
    var fmId: String?//支付方式描述
    var msg: String?//返回支付信息
    
    var pay_acount: String?//支付账户
    var pay_ebcode: String?//支付方式描述
    var pay_id: String?//返回支付信息
    var pay_order: ModelorderWXItem?//微信支付model信息
    
    var pay_transId: String?//支付账户
    var statusCode: String?//支付方式描述
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        actInfo <- map["actInfo"]
        biz_content <- map["biz_content"]
        fmId <- map["fmId"]
        msg <- map["msg"]
        
        pay_acount <- map["pay_acount"]
        pay_ebcode <- map["pay_ebcode"]
        pay_id <- map["pay_id"]
        pay_order <- map["pay_order"]
        
        pay_transId <- map["pay_transId"]
        statusCode <- map["statusCode"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelorderWXItem: Mappable {
    var appid: String?
    var mch_id: String?
    var nonce_str: String?
    var package: String?
    
    var prepay_id: String?
    var sign: String?
    var pay_id: String?
    var timestamp: String?
    
    var trade_type: String?

    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        appid <- map["appid"]
        mch_id <- map["mch_id"]
        nonce_str <- map["nonce_str"]
        package <- map["package"]
        
        prepay_id <- map["prepay_id"]
        sign <- map["sign"]
        pay_id <- map["pay_id"]
        timestamp <- map["timestamp"]
        
        trade_type <- map["trade_type"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelOrderPayBack: Mappable {
    var StatusCode: String?//支付状态码
    var payAcount: String?//支付账户
    var payId: String?//支付方式描述
    var msg: String?//返回支付信息
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        StatusCode <- map["StatusCode"]
        payAcount <- map["payAcount"]
        payId <- map["payId"]
        msg <- map["msg"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:批量订单支付确认 postmodel

class ModelOrderPayAccessListPost:Mappable {
    var orders:[ModelOrderPayAccessOrdersItem]?           //oidlist
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        orders <- map["orders"]
    }
}

class ModelOrderPayAccessOrdersItem:Mappable {
    var orderId:String?           //orderId
    init() {
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        orderId <- map["orderId"]
    }
}

//MARK:批量订单支付确认 返回model

class ModelOrderPayAccessListBack:Mappable {
    var data:ModelPayAccessOrders?
    var errcode:String?
    var errmsg:String?
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
    }
}

class ModelPayAccessOrders:Mappable {
    var alipayAmount:String?
    var fmId:String?
    var mcouponAmount:String?
    var operatorId:String?
    var payDate:String?
    
    var payEbcode:String?
    var payId:String?
    var payTransId:String?
    var refundAmount:String?
    var stationId:String?
    
    var statusCode:String?
    var storeId:String?
    var totalAmount:String?
    var ver:String?
    
    init() {
        
    }
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        alipayAmount <- map["alipayAmount"]
        fmId <- map["fmId"]
        mcouponAmount <- map["mcouponAmount"]
        operatorId <- map["operatorId"]
        payDate <- map["payDate"]
        
        payEbcode <- map["payEbcode"]
        payId <- map["payId"]
        payTransId <- map["payTransId"]
        refundAmount <- map["refundAmount"]
        stationId <- map["stationId"]
        
        statusCode <- map["statusCode"]
        storeId <- map["storeId"]
        totalAmount <- map["totalAmount"]
        ver <- map["ver"]
    }
}

//MARK:订单支付确认 postmodel

class ModelOrderPayAccessPost: Reflect {
    /**
     *  订单ID
     *  必传:True 
     */
    var orderId:String!
}

//MARK:订单支付确认 backModel

class ModelOrderPayAccessBack: Mappable {
    var errmsg: String?//支付状态码
    var errcode: String?//返回支付信息
    var data: ModelOrderPayAccesItem?//返回支付信息
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
        data <- map["data"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:订单支付确认 backModel

class ModelOrderPayAccesItem: Mappable {
    var alipayAmount: String?//
    var fmId: String?//
    var mcouponAmount: Int?//
    
    var operatorId: String?//
    var payDate: String?//
    var payEbcode: String?//
    
    var payId: String?
    var payTransId: String?
    var refundAmount: Int?
    
    var stationId: String?
    var statusCode: Int?
    var storeId: String?
    
    var totalAmount: Int?
    var ver: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        alipayAmount <- map["alipayAmount"]
        fmId <- map["fmId"]
        mcouponAmount <- map["mcouponAmount"]
        
        operatorId <- map["operatorId"]
        payDate <- map["payDate"]
        payEbcode <- map["payEbcode"]
        
        payId <- map["payId"]
        payTransId <- map["payTransId"]
        refundAmount <- map["refundAmount"]
        
        stationId <- map["stationId"]
        statusCode <- map["statusCode"]
        storeId <- map["storeId"]
        
        totalAmount <- map["totalAmount"]
        ver <- map["ver"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:订单接单 postmodel

class ModelOrderAcceptPost: Reflect {
    /**
     *  订单ID
     *  必传:True 
     */
    var orderId:String!
    
}

//MARK:查询各状态订单数量 postmodel

class ModelOrderNumUserPost: Reflect {
    var userId:String!///用户ID
}

class ModelOrderNumResult:Mappable {
    var data: ModelOrderCount?
    var errcode: Int?
    var errmsg: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelOrderCount:Mappable {
    var alReadySend:Int?
    var allOrders:Int?
    var readyComment:Int?
    var readyPay:Int?
    var readySend:Int?
    var readyTake:Int?
    var refundAfter:Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        alReadySend <- map["alReadySend"]
        allOrders <- map["allOrders"]
        readyComment <- map["readyComment"]
        readyPay <- map["readyPay"]
        readySend <- map["readySend"]
        readyTake <- map["readyTake"]
        refundAfter <- map["refundAfter"]

    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:查询全部订单 postmodel

class ModelListPageByUserPost: Reflect {
    var userId:String!///用户ID
    var pagesize:Int!///分页大小
    var pagenumber:Int!///分页数
    
}

//MARK:查询全部订单 postmodel

class ModelListPageByStatusPost: Reflect {
    var userId:String!///用户ID
    var pagesize:Int!///分页大小
    var pagenumber:Int!///分页数
    var status:Int!///订单状态，参见订单状态表
    
}

class ModelOrderListResult:Mappable {
    var data: ModelOrderWithCount?
    var errcode: String?
    var errmsg: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelOrderWithCount:Mappable {
    var count:Int?
    var orders:[ModelListPageByUserBack]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        count <- map["count"]
        orders <- map["orders"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }

}

class ModelListPageByUserBack: Mappable {
    
    var accounts: [ModelListPageByUserAccountItem]?//其他结算列表
    var address: String?//收货地址
    var amount: Int?//订单金额(分)
    var cancelReason: String?//adding
    var companyId: String?//商户ID
    
    var customerOrder: String?//第三方订单编号
    var evaluateStatus: Int?//adding
    var gmtCreate: Int?//adding
    var longitude: String?//收货地址经度
    var latitude: String?//收货地址纬度
    
    var oid: Int?//订单ID
    var partition: String?//拆单信息
    var payChannel: String?//支付渠道
    var payChannelName: String?//支付渠道名称
    var payStatus: Int?//adding
    
    var payType: Int?//支付金额
    var phone: String?//用户电话
    var products: [ModelShopDetailItem]?//商品列表
    var remark: String?//订单备注
    var shopId: String?//门店ID
    
    var shopName: String?//门店名称
    var source: String?//订单来源
    var status: Int?//订单状态
    var type: Int?//订单类型
    var userId: String?//用户ID
    
    var userName: String?//用户名称
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        accounts <- map["accounts"]
        address <- map["address"]
        amount <- map["amount"]
        cancelReason <- map["cancelReason"]
        companyId <- map["companyId"]
        
        customerOrder <- map["customerOrder"]
        evaluateStatus <- map["evaluateStatus"]
        gmtCreate <- map["gmtCreate"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        
        oid <- map["oid"]
        partition <- map["partition"]
        payChannel <- map["payChannel"]
        payChannelName <- map["payChannelName"]
        payStatus <- map["payStatus"]
        
        payType <- map["payType"]
        phone <- map["phone"]
        products <- map["products"]
        remark <- map["remark"]
        shopId <- map["shopId"]
        
        shopName <- map["shopName"]
        source <- map["source"]
        status <- map["status"]
        type <- map["type"]
        userId <- map["userId"]
        
        userName <- map["userName"]

        
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:查询订单详细 postmodel

class ModelOrderDetailPost: Reflect {
    var orderId:String!///订单ID
}
//MARK:查询订单详细 back

class ModelOrderDetailResult:Mappable {
    var data: ModelOrderDetailInfo?
    var errcode: String?
    var errmsg: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        data <- map["data"]
        errcode <- map["errcode"]
        errmsg <- map["errmsg"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelOrderDetailInfo: Mappable {
    
    var accountList: [ModelListPageByUserAccountItem]?//其他结算列表
    var address: String?//收货地址
    var amount: Int?//订单金额(分)
    var barCounter: String?//???
    var cancelReason: String?//adding
    var companyId: String?//商户ID
    
    var createUser: String?//???
    var customerOrder: String?//第三方订单编号
    var evaluateStatus: Int?//adding
    var gmtAccept: Int?//???
    var gmtCreate: Int?//adding
    var gmtModified: Int?//???
    var gmtPay: Int?//???
    var longitude: String?//收货地址经度
    var latitude: String?//收货地址纬度
    
    var oid: Int?//订单ID
    var partition: String?//拆单信息
    var payChannel: String?//支付渠道
    var payChannelName: String?//支付渠道名称
    var payStatus: Int?//adding
    
    var payType: Int?//支付金额
    var payVoucher: String?//???
    var phone: String?//用户电话
    var posId: String?//???
    var productList: [ModelListPageByUserProductItem]?//商品列表
    var remark: String?//订单备注
    var shopId: String?//门店ID
    
    var shopName: String?//门店名称
    var source: String?//订单来源
    var sourceName: String?//???
    var status: Int?//订单状态
    var type: Int?//订单类型
    var userId: String?//用户ID
    
    var userName: String?//用户名称
    var userType: String?//???
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        accountList <- map["accountList"]
        address <- map["address"]
        amount <- map["amount"]
        barCounter <- map["barCounter"]
        cancelReason <- map["cancelReason"]
        companyId <- map["companyId"]
        
        createUser <- map["createUser"]
        customerOrder <- map["customerOrder"]
        evaluateStatus <- map["evaluateStatus"]
        gmtAccept <- map["gmtAccept"]
        gmtCreate <- map["gmtCreate"]
        gmtModified <- map["gmtModified"]
        gmtPay <- map["gmtPay"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        
        oid <- map["oid"]
        partition <- map["partition"]
        payChannel <- map["payChannel"]
        payChannelName <- map["payChannelName"]
        payStatus <- map["payStatus"]
        
        payType <- map["payType"]
        payVoucher <- map["payVoucher"]
        phone <- map["phone"]
        posId <- map["posId"]
        productList <- map["productList"]
        remark <- map["remark"]
        shopId <- map["shopId"]
        
        shopName <- map["shopName"]
        source <- map["source"]
        sourceName <- map["sourceName"]
        status <- map["status"]
        type <- map["type"]
        userId <- map["userId"]
        
        userName <- map["userName"]
        userType <- map["userType"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelListPageByUserProductItem: Mappable {
    
    var number: Int?//商品数量
    var orderId: Int?//商品数量
    var parentProduct: Int?//???
    var price: String?//商品单价分
    var productId: String?//商品ID
    var productName: String?//商品名称
    
    var specification: String?//商品规格
    var sequence: String?//排序
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        number <- map["number"]
        orderId <- map["orderId"]
        parentProduct <- map["parentProduct"]
        price <- map["price"]
        productId <- map["productId"]
        productName <- map["productName"]
        
        specification <- map["specification"]
        sequence <- map["sequence"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:订单支付确认 backModel

class ModelListPageByUserAccountItem: Mappable {
    var accountId: String?//结算对象ID
    var name: String?//结算对象名称
    var number: Int?//结算数量
    var orderId: Int?//
    var price: Int?//结算金额
    
    var type: Int?//结算对象类型
    var sequence: Int?//排序
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        accountId <- map["accountId"]
        name <- map["name"]
        number <- map["number"]
        orderId <- map["orderId"]
        type <- map["type"]
        
        price <- map["price"]
        sequence <- map["sequence"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:订单设置地址 postmodel

class ModelorderAddressSetPost: Reflect {
    var orderId:String!  ///<订单ID
    var address:Int!   ///<配送地址
    var longitude:Int! ///<经度
    var latitude:Int! ///<纬度
}

class ModelorderAddressSetBack:Mappable {
    var status_code:Int?
    var msg:String?
    var result:[ModelListPageByUserBack]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        status_code <- map["status_code"]
        msg <- map["msg"]
        result <- map["result"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelorderAddressResult:Mappable {
    var msg:String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        msg <- map["msg"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}
