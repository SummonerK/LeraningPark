//
//  FMCodeManager.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/28.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FMCODE_DEFAULT = 999,///<调取支付异常
    FMCODE_NET_DEFAULT = 500,///<调取支付异常
    
    FMCODE_AL_OPEN = 101,///<打开支付宝成功
    FMCODE_AL_OPEN_ERROR = 102,///<打开支付宝失败
    FMCODE_AL_PAY = 103,///<支付宝支付成功
    FMCODE_AL_PAY_CANCEL = 104,///<支付宝支付取消
    FMCODE_AL_PAY_ERROR = 105,///<支付宝支付失败
    
    FMCODE_WX_OPEN = 201,///<打开微信成功
    FMCODE_WX_OPEN_ERROR = 202,///<打开微信失败
    FMCODE_WX_PAY = 203,///<微信支付成功
    FMCODE_WX_PAY_CANCEL = 204,///<微信支付取消
    FMCODE_WX_PAY_ERROR = 205,///<微信支付失败
    FMCODE_WX_INSTALL = 206,///<微信未安装
    
    FMCODE_UN_OPEN = 301,///<打开银联支付成功
    FMCODE_UN_OPEN_ERROR = 302,///<打开银联支付失败
    FMCODE_UN_PAY = 303,///<银联支付成功
    FMCODE_UN_PAY_CANCEL = 304,///<银联支付取消
    FMCODE_UN_PAY_ERROR = 305,///<银联支付失败
    FMCODE_UN_TNCODE = 306,///<未获取TN号
    
} FMRESULTCODE;

@interface FMCodeManager : NSObject

@end
