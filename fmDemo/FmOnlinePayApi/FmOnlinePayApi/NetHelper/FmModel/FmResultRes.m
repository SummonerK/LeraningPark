//
//  FmResultRes.m
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/28.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "FmResultRes.h"

@implementation FmResultRes

- (void)setResultCode:(FMRESULTCODE)resultCode{
    _resultCode = resultCode;
    switch (resultCode) {
        case FMCODE_DEFAULT:
        {
            self.resultMsg = @"支付类型出错";
        }
            break;
        case FMCODE_VERIFY_DEFAULT:
        {
            self.resultMsg = @"支付验证失败";
        }
            break;
        case FMCODE_PAY_DEFAULT:
        {
            self.resultMsg = @"支付成功";
        }
            break;
#pragma mark AL 支付宝
            
            /*
        case FMCODE_AL_OPEN:
        {
            self.resultMsg = @"打开支付宝成功";
        }
            break;
        case FMCODE_AL_OPEN_ERROR:
        {
            self.resultMsg = @"打开支付宝失败";
        }
            break;
        case FMCODE_AL_PAY:
        {
            self.resultMsg = @"支付宝支付成功";
        }
            break;
        case FMCODE_AL_PAY_CANCEL:
        {
            self.resultMsg = @"支付宝支付取消";
        }
            break;
        case FMCODE_AL_PAY_ERROR:
        {
            self.resultMsg = @"支付宝支付失败";
        }
            break;
             
             */
            
#pragma mark WX 微信
        case FMCODE_WX_OPEN:
        {
            self.resultMsg = @"打开微信成功";
        }
            break;
        case FMCODE_WX_OPEN_ERROR:
        {
            self.resultMsg = @"打开微信失败";
        }
            break;
        case FMCODE_WX_PAY:
        {
            self.resultMsg = @"微信支付成功";
        }
            break;
        case FMCODE_WX_PAY_CANCEL:
        {
            self.resultMsg = @"微信支付取消";
        }
            break;
        case FMCODE_WX_PAY_ERROR:
        {
            self.resultMsg = @"微信支付异常(appid异常或其他";
        }
            break;
        case FMCODE_WX_INSTALL:
        {
            self.resultMsg = @"微信未安装";
        }
            break;
            
#pragma mark UN 银联
        case FMCODE_UN_OPEN:
        {
            self.resultMsg = @"打开银联成功";
        }
            break;
        case FMCODE_UN_OPEN_ERROR:
        {
            self.resultMsg = @"打开银联失败";
        }
            break;
        case FMCODE_UN_PAY:
        {
            self.resultMsg = @"银联支付成功";
        }
            break;
        case FMCODE_UN_PAY_CANCEL:
        {
            self.resultMsg = @"银联支付取消";
        }
            break;
        case FMCODE_UN_PAY_ERROR:
        {
            self.resultMsg = @"银联支付失败";
        }
            break;
        case FMCODE_UN_TNCODE:
        {
            self.resultMsg = @"未获取到TN号";
        }
            break;
            
        default:
            break;
    }
}

@end
