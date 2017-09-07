//
//  FMCodeManager.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/28.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FMCODE_DEFAULT = 999,///<调取支付异常，支付平台不支持
    FMCODE_VERIFY_DEFAULT = 1000,///<调取支付验证信息失败
    FMCODE_PAY_DEFAULT = 0,///<支付成功
    
    FMCODE_WX_OPEN = 2001,///<打开微信成功
    FMCODE_WX_OPEN_ERROR = 2002,///<打开微信失败
    FMCODE_WX_PAY = 2003,///<微信支付成功
    FMCODE_WX_PAY_CANCEL = 2004,///<微信支付取消
    FMCODE_WX_PAY_ERROR = 2005,///<微信支付失败
    FMCODE_WX_INSTALL = 2006,///<微信未安装
    
    FMCODE_UN_OPEN = 3001,///<打开银联支付成功
    FMCODE_UN_OPEN_ERROR = 3002,///<打开银联支付失败
    FMCODE_UN_PAY = 3003,///<银联支付成功
    FMCODE_UN_PAY_CANCEL = 3004,///<银联支付取消
    FMCODE_UN_PAY_ERROR = 3005,///<银联支付失败
    FMCODE_UN_TNCODE = 3006,///<未获取TN号
    
} FMRESULTCODE;

@interface FMCodeManager : NSObject

@end
