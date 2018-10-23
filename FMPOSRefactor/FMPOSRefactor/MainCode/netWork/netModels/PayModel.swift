//
//  PayModel.swift
//  FMPOS-Master
//
//  Created by 舒圆波 on 18/7/31.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 *  注：字段标注N 为不必填 改请求和响应为3个接口(支付、查询、退款)统一
 *  ，自取所需要参数传入
 *  注: 支付渠道编号 支付宝 10001  微信 10004
 *  注：异常码说明 21参数错误(失败) 41交易不存在(失败) 51门店已经被锁定(失败) 201 支付账号不存在(失败) 202 账户异常(失败) 203账户余额不足 (失败)
        204 交易超时或支付平台异常(需查询判断支付结果) 206退款金额高于支付金额(失败) 500系统错误(需查询判断支付结果)
 */
//MARK: 支付、查询、退款入参
class PayReq: Mappable {
    //查询
    var ver: Int!
    var reqtype: Int?               //52为查询 62为退款72 为支付
    var partnerId: Int?             //
    var store_id: String?
    var operator_id:String?         //用户名
    var trans_id: String?           //查询固定传0，暂定为时间戳
    var fmId: String?               //非码交易号
    var station_id: String?         //设备id
    //支付退款额外字段
    var sign: String?               //N
    var business_date: String?      //N 营业日 yyyyMMdd
    var refund_id: String?          //N 退款标识，暂定为时间戳
    var transactions: [TransInfoReq]?    //支付参数
    
    init() {
        ver = 2
        reqtype = 52
        partnerId = 1371
        store_id = "fm99999"
        operator_id = "fm99999"
        trans_id = "0"
        fmId = "test"
        station_id = "deviceId"
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        ver <- map["ver"]
        reqtype <- map["reqtype"]
        partnerId <- map["partnerId"]
        store_id <- map["store_id"]
        operator_id <- map["operator_id"]
        trans_id <- map["trans_id"]
        fmId <- map["fmId"]
        station_id <- map["station_id"]
        
        sign <- map["sign"]
        refund_id <- map["refund_id"]
        business_date <- map["business_date"]
        transactions <- map["transactions"]
    }
}

class TransInfoReq: Mappable {
    //支付的交易信息
    var pay_ebcode: String?         //N 支付渠道编号
    var undis_amount: Int?          //N 不可打折金额
    var invoice_flag: Int?          //N 1为需要开发票
    var amount: Int?                //支付金额  分为单位
    var code: String?               //支付条码
    //退款的交易信息
    var fmId: String?               //非码交易序号 扫码取得
    var refund_count:Int?           //退款金额 分
    
    init() {
        
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        pay_ebcode <- map["pay_ebcode"]
        undis_amount <- map["undis_amount"]
        invoice_flag <- map["invoice_flag"]

        amount <- map["amount"]
        code <- map["code"]
        
        fmId <- map["fmId"]
        refund_count <- map["refund_count"]
    }
    
}
//MARK: 支付、查询、退款出参,支付相应请直接使用PayRes，不需要套base
class PayRes: Mappable {
    //查询响应
    var statusCode: Int?        //100为成功
    var pay_account: String?    //支付账号
    var pay_transId: String?    //三方交易序号
    var fmId: String?           //非码交易序号
    var total_amount: Int?      //总金额
    var mcoupon_amount:Int?     //平台优惠金额
    var pcoupon_amount: Int?    //商家优惠金额
    var refund_amount: Int?     //退款金额
    var alipay_amount: Int?     //实付金额
    var pay_ebcode: String?     //支付渠道编号
    var ver: String?            //固定2
    var pay_date: String?       //交易时间
    var store_id: String?
    var station_id:String?
    var operator_id: String?
    //支付额外
    var pay_id: String?         //支付方式描述
    var ext: PayExtRes?         //扩展信息 暂不用
    
    required init?(map: Map) {
        mcoupon_amount = 0
        pcoupon_amount = 0
    }
    
    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        pay_account <- map["pay_acount"]
        pay_transId <- map["pay_transId"]
        fmId <- map["fmId"]
        total_amount <- map["total_amount"]
        mcoupon_amount <- map["mcoupon_amount"]
        pcoupon_amount <- map["pcoupon_amount"]
        refund_amount <- map["refund_amount"]
        alipay_amount <- map["alipay_amount"]
        ver <- map["ver"]
        pay_ebcode <- map["pay_ebcode"]
        pay_date <- map["pay_date"]
        store_id <- map["store_id"]
        station_id <- map["station_id"]
        operator_id <- map["operator_id"]
        
        pay_id <- map["pay_id"]
        ext <- map["ext"]
    }
}

class PayExtRes: Mappable {
    var print: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        print <- map["print"]
    }
}
