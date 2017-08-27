//
//  NetHelper.m
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "NetHelper.h"
#import "FmWxPrepayRes.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString * const HOSTPath   = @"http://115.159.117.231:9000/";
static NSInteger const TIMEOUT  = 30;

typedef void (^FmPayCompletionBlock)(NSDictionary* FmPayCallBackRes);


@implementation NetHelper 


+ (instancetype)sharedInstance {
    static NetHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NetHelper alloc] initWithBaseURL:[NSURL URLWithString:HOSTPath]];
        _sharedInstance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedInstance.requestSerializer.timeoutInterval =TIMEOUT;
        
    });
    return _sharedInstance;
}


///////////////////////////////////////////////////////////////////////
- (void)getPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock
{
    [self GET:path parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] intValue]==200) {
            successBlock(responseObject);
        }else
        {
            failureBlock(responseObject[@"code"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        failureBlock([error localizedDescription]);
    } ];
}
/**
 *post
 */
- (void)postPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock
{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self POST:path parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([responseObject[@"statusCode"] intValue]==100) {
            successBlock(responseObject);
        }else
        {
            failureBlock(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        failureBlock([error localizedDescription]);
    } ];
}

- (void)initApi:(NSString*)wxAppID{
    [WXApi registerApp:wxAppID];
}

- (BOOL)handlePayOpen:(NSURL*)url{
    
    if ([[url host] isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:FMNet];
    }else if([[url host] isEqualToString:@"safepay"]) {
        [AlipaySDK.defaultService processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            int aliStatus = [resultDic[@"resultStatus"] intValue];
            NSLog(@"返回app------调起支付结果\n----阿里---");
            if (aliStatus == 9000) {
                NSLog(@"成功");
                return;
            }else{
                NSLog(@"失败");
            }
        }];
    }
    
    return NO;
    
}

/**
 *.	getVerifyCode	【获取支付签名】
 */
- (void)fmPayGetPaySignWithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    [self postPath:@"account/pay/getSign" WithParameter:parameter successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSString *error) {
        failureBlock(error);
    }];
}

- (void)fmCreatPay:(FmPrepayModel*)payModel AndScheme:(NSString*)shchme successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    NSLog(@"%@",payModel.toJSONString);
    
    [FMNet fmPayGetPaySignWithParameter:payModel.toDictionary successBlock:^(id responseBody) {
        
        FmWxPrepayRes * SentResult = [[FmWxPrepayRes alloc] initWithDictionary:responseBody error:nil];
        
        FmWxPrepayDataRes * wContent = [[FmWxPrepayDataRes alloc] initWithDictionary:responseBody[@"responseData"] error:nil];
        
        SentResult.responseData = wContent;
        
        NSLog(@"SentResult = %@",SentResult);
        
        if ([SentResult.paymentMethodCode  isEqual: @"20002"]) {
            //支付宝支付
            
            [FMNet doAliPay:wContent.biz_content AndScheme:shchme successBlock:^(id responseBody) {
                successBlock(responseBody);
            } failureBlock:^(NSString *error) {
                failureBlock(error);
            }];
            
        }else if([SentResult.paymentMethodCode  isEqual: @"20001"]) {
            //微信支付
            [FMNet doWxPay:SentResult successBlock:^(id responseBody) {
                successBlock(responseBody);
            } failureBlock:^(NSString *error) {
                failureBlock(error);
            }];
        }
        
    } failureBlock:^(NSString *error) {
        failureBlock(error);
    }];
    
}

- (void)doAliPay:(NSString*)bizContent AndScheme:(NSString*)shchme successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    [[AlipaySDK defaultService] payOrder:bizContent fromScheme:shchme callback:^(NSDictionary *resultDic) {
        int aliStatus = [resultDic[@"resultStatus"] intValue];
        if (aliStatus == 9000) {
            successBlock(resultDic);
        }else{
            failureBlock(resultDic[@"memo"]);
        }
    }];
}

- (void)doWxPay:(FmWxPrepayRes*)wxPreRes successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    if (![WXApi isWXAppInstalled]) {
        failureBlock(@"未检测到微信");
    }
    
    PayReq * payModel = [PayReq new];
    payModel.openID = wxPreRes.responseData.appid;
    payModel.partnerId = wxPreRes.responseData.partnerid;
    payModel.prepayId = wxPreRes.responseData.prepayid;
    payModel.package = wxPreRes.responseData.package;
    payModel.nonceStr = wxPreRes.responseData.noncestr;
    payModel.timeStamp = [wxPreRes.responseData.timestamp intValue];
    payModel.sign = wxPreRes.sign;
    
    BOOL isOpenWx = [WXApi sendReq:payModel];
    
    if (!isOpenWx) {
        failureBlock(@"打开微信失败");
    }else{
        successBlock(@{@"msg":@"打开微信，支付中"});
    }
    
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp * response = (PayResp*)resp;
        
        NSLog(@"返回app------调起支付结果\n----微信---");
        
        switch (response.errCode) {
            case 0:
                NSLog(@"成功");
                break;
                
            default:
                NSLog(@"失败");
                break;
        }
    }
}

@end
