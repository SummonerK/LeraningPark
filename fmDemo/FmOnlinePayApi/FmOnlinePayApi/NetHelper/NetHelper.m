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
#import "UPPaymentControl.h"
#import "RSAFISHER.h"
//#import "pontedEncry.h"

static NSString * const HOSTPath   = @"http://115.159.117.231:8905/";
//static NSString * const HOSTPath   = @"http://172.16.13.207:8905/";
static NSInteger const TIMEOUT  = 30;

typedef void (^NetSuccess)(id responseBody);
typedef void (^NetFail)(id error);

static NSString * const app_private_key = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANb1LukQ3Kw/43t20SN/yyXdF5FS1T0VfsOY1PW01hXntvk+6Xz9C3VNrgTDNlKobW4KZy1xR8eI1hSWSpS4zwGXk2Hz07x0Jg+GNv9Q+Q/J9eq/QcYXw4g4+FwrAREEtIQr67LT/LOpkWq/An1QI07dU8AyCCSGafeEGMO5v6N3AgMBAAECgYASgI4mH35vERy6ftKnlJNe0fX6Wz/hfx0nJtuFvqgCwKweLg0Y5gr7cNE+tbLSUI8CvsB8x9he02dh5EHNJU8j8ohezpUoXI+omnw2gV+zj4dvvDcW1sTFt1mG/Snv08yXuXTIBEenuSPfqToNUrYrlU1uFeUQH6VWFDzgd5TIgQJBAPMSGHoXszwmbzdNi03C6imnVKQmuvYH/HFXPP2MQrHalGWmXI5UMYCOwdjrG7yNFxgIeFvIsPTXcYbE/BebmsECQQDiZEXBnwoYANgTg+N9Uz1lWxmMS99A+Rt/x1Ft8o9YagvRgKzbtMLt/JZsewPflExl5oPRNCaF7wZCLH4MXmQ3AkB/5tS0YgYxL3Q0IHydtWOr+V2jZrHYRkmChkoUjJqHpaGSf2CSkCDgKb482zHkHEW7orFacpcSrs8RAFQ6Q+nBAkBXGltYXpdkmtaH06OwMVma6I0Q1JRGDFIPPKHQ2pVaYBrB9W8MbSTeqeM6Q64+1HD8d89Zq2Xy+/79cN7iZWLLAkEA2ZbVP2N3nOWadvskoAtPDKzHKQ4FnodnGvnKRM0pNC3jOKGvvMjLcgqg6h7lueRo46Pj6wotziBsI2PtYFzNBg==";

static NSString * const app_public_key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCP2ShTLxG96nCLSO0Rx/7XnMxaeW8mDDXoOGfwaY9O2EF4m5xxUPh95zdhTvPZGZJCReikZOQAZRObkuTvc48inzdXGHBq/aix6v20ZTkK+R/mSlYmYKH5MiP3qbmPAovF7y17dJmXG45DrGOTq8i6HPYLm6C7GCvhO5r5pc5LqwIDAQAB";

@interface NetHelper() <WXApiDelegate>{
    SuccessBlock mSuccess;
    FailureBlock mFail;
    FmResultRes * ResultMdel;
}

@end

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
- (void)getPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(NetSuccess )successBlock failureBlock:(NetFail)failureBlock
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
- (void)postPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(NetSuccess )successBlock failureBlock:(NetFail)failureBlock
{
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self POST:path parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([responseObject[@"statusCode"] intValue]==100) {
            successBlock(responseObject);
        }else
        {
            failureBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        NSDictionary * ErrorDic = @{@"statusCode":[NSString stringWithFormat:@"%d",(int)[error code]],@"message":[error localizedDescription]};
        failureBlock(ErrorDic);
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
                ResultMdel.resultCode = FMCODE_PAY_DEFAULT;
                mSuccess(ResultMdel);
                return;
            }else{
                ResultMdel.resultCode = aliStatus;
                if (![resultDic[@"memo"] isEqualToString:@""]) {
                    ResultMdel.resultMsg = resultDic[@"memo"];
                }else{
                    ResultMdel.resultMsg = @"支付取消";
                }
                
                mFail(ResultMdel);
            }
        }];
    }else if([[url host] isEqualToString:@"uppayresult"]){
        [UPPaymentControl.defaultControl handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            NSLog(@"返回app------调起支付结果\n----银联---");
            if ([code isEqualToString:@"fail"]) {
                ResultMdel.resultCode = FMCODE_UN_PAY_ERROR;
                mFail(ResultMdel);
            }else if ([code isEqualToString:@"cancel"]){
                ResultMdel.resultCode = FMCODE_UN_PAY_CANCEL;
                mFail(ResultMdel);
            }else if ([code isEqualToString:@"success"]){
                ResultMdel.resultCode = FMCODE_PAY_DEFAULT;
                mSuccess(ResultMdel);
            }
        }];
    }
    
    return NO;
    
}

/**
 *.	getVerifyCode	【获取支付签名】
 */
- (void)fmPayGetPaySignWithParameter:(NSDictionary *)parameter successBlock:(NetSuccess )successBlock failureBlock:(NetFail)failureBlock{
    
    [self postPath:@"unifyOrder" WithParameter:parameter successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(id error) {
        failureBlock(error);
    }];
}

- (void)fmCreatPay:(FmPrepayModel*)payModel AndScheme:(NSString*)shchme AndMode:(NSString*)mode AndViewController:(UIViewController*)ViewC successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{

    mSuccess = successBlock;
    mFail = failureBlock;
    ResultMdel = [FmResultRes new];
    FmResponseData * responsedata = [FmResponseData new];
    ResultMdel.responseData = responsedata;
    
    //加密拼接
    payModel.sign = [FMNet getNeedSignStrFrom:payModel.toDictionary];
    
//    NSLog(@"payModel Json ==> %@",payModel.toJSONString);
    
//    /*
    
    [FMNet fmPayGetPaySignWithParameter:payModel.toDictionary successBlock:^(id responseBody) {
        
//        NSLog(@"responseBody = %@",responseBody);
        
        FmWxPrepayRes * SentResult = [[FmWxPrepayRes alloc] initWithDictionary:responseBody error:nil];
        
        FmWxPrepayDataRes * wContent = [[FmWxPrepayDataRes alloc] initWithDictionary:responseBody[@"responseData"] error:nil];
        responsedata.fmId = SentResult.fmId;
        
        SentResult.responseData = wContent;
        
//        NSLog(@"SentResult = %@",SentResult);
        
        if (![self getVerifyFrom:SentResult.toDictionary]) {
            ResultMdel.resultCode = FMCODE_VERIFY_DEFAULT;
            failureBlock(ResultMdel);
            return;
        }
        
        if ([SentResult.paymentMethodCode  isEqual: @"20002"]) {
            //支付宝支付
            
            [FMNet doAliPay:wContent.biz_content AndScheme:shchme successBlock:^(FmResultRes *result) {
                successBlock(result);
            } failureBlock:^(FmResultRes *error) {
                failureBlock(error);
            }];
            
        }else if([SentResult.paymentMethodCode  isEqual: @"20001"]) {
            //微信支付
            [FMNet doWxPay:SentResult successBlock:^(FmResultRes *result) {
                successBlock(result);
            } failureBlock:^(FmResultRes *error) {
                failureBlock(error);
            }];
        }else if ([SentResult.paymentMethodCode  isEqual: @"20003"]){
            
            [FMNet doPayUnion:wContent.tn scheme:shchme AndMode:mode withVC:ViewC successBlock:^(FmResultRes *result) {
                successBlock(result);
            } failureBlock:^(FmResultRes *error) {
                failureBlock(error);
            }];
        }else{
            ResultMdel.resultCode = FMCODE_DEFAULT;
            failureBlock(ResultMdel);
        }
        
    } failureBlock:^(id error) {
        ResultMdel.resultCode =  [error[@"statusCode"] intValue];
        ResultMdel.resultMsg = error[@"message"];
        failureBlock(ResultMdel);
    }];
    
//     */
}

- (void)doAliPay:(NSString*)bizContent AndScheme:(NSString*)shchme successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    [[AlipaySDK defaultService] payOrder:bizContent fromScheme:shchme callback:^(NSDictionary *resultDic) {
        int aliStatus = [resultDic[@"resultStatus"] intValue];
        if (aliStatus == 9000) {
            ResultMdel.resultCode = FMCODE_PAY_DEFAULT;
            successBlock(ResultMdel);
        }else{
            ResultMdel.resultCode = aliStatus;
            
            if (![resultDic[@"memo"] isEqualToString:@""]) {
                ResultMdel.resultMsg = resultDic[@"memo"];
            }else{
                ResultMdel.resultMsg = @"支付取消";
            }
            
            failureBlock(ResultMdel);
            
        }
    }];
}

- (void)doWxPay:(FmWxPrepayRes*)wxPreRes successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    if (![WXApi isWXAppInstalled]) {
        ResultMdel.resultCode = FMCODE_WX_INSTALL;
        failureBlock(ResultMdel);
        return;
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
        ResultMdel.resultCode = FMCODE_WX_OPEN_ERROR;
        failureBlock(ResultMdel);
    }else{
        ResultMdel.resultCode = FMCODE_WX_OPEN;
        successBlock(ResultMdel);
    }
    
}

- (void)doPayUnion:(NSString*)tn scheme:(NSString*)scheme AndMode:(NSString*)mode withVC:(UIViewController*)viewvc successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    if ([tn isEqualToString:@""]) {
        ResultMdel.resultCode = FMCODE_UN_TNCODE;
        failureBlock(ResultMdel);
        return;
    }
    
    if ([UPPaymentControl.defaultControl startPay:tn fromScheme:scheme mode:mode viewController:viewvc]){
        ResultMdel.resultCode = FMCODE_UN_OPEN;
        successBlock(ResultMdel);
    }else{
        ResultMdel.resultCode = FMCODE_UN_OPEN_ERROR;
        failureBlock(ResultMdel);
    }
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp * response = (PayResp*)resp;
        
        NSLog(@"返回app------调起支付结果\n----微信---");
        
        switch (response.errCode) {
            case 0:{
                ResultMdel.resultCode = FMCODE_PAY_DEFAULT;
                mSuccess(ResultMdel);
            }
                break;
            case -1:{
                ResultMdel.resultCode = FMCODE_WX_PAY_ERROR;
                mFail(ResultMdel);
            }
                break;
            case -2:{
                ResultMdel.resultCode = FMCODE_WX_PAY_CANCEL;
                mFail(ResultMdel);
            }
                break;
            default:
                NSLog(@"失败");
                break;
        }
    }
}

- (NSString *)getNeedSignStrFrom:(NSDictionary*)Temp{
    
    NSMutableArray * arrayPrimary = [[NSMutableArray alloc] initWithArray:Temp.allKeys];
    
    [arrayPrimary removeObject:@"products"];
    [arrayPrimary removeObject:@"sign"];
    
    NSArray *arrKey = [arrayPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;//NSOrderedAscending 倒序
    }];
    
    NSString*str =@"";
    NSString *encWithPrivKey;
    
    for (NSString *s in arrKey) {
        id value = Temp[s];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self getNeedSignStrFrom:value];
        }
        if([str length] !=0) {
            str = [str stringByAppendingString:@"|"];
        }
        str = [str stringByAppendingFormat:@"%@",value];
        
    }
    
//    NSLog(@"keys:%@",[arrKey componentsJoinedByString:@"|"]);
//    NSLog(@"str:%@",str);
    
//    str = @"1447|1504250617|20002|-1|-1|2|0|1";
    
    encWithPrivKey = [RSAFISHER encryptString:str privateKey:app_private_key];
    
//    NSLog(@"app_private_key signResult: \n%@\nend", encWithPrivKey);
    
    return encWithPrivKey;
    
}

- (BOOL)getVerifyFrom:(NSDictionary*)Temp{
    
    NSMutableArray * arrayPrimary = [[NSMutableArray alloc] initWithArray:Temp.allKeys];
    
    [arrayPrimary removeObject:@"responseData"];
    [arrayPrimary removeObject:@"sign"];
    
    NSArray *arrKey = [arrayPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;//NSOrderedAscending 倒序
    }];
    
    NSString*str =@"";
    NSString *pubSign;
    
    for (NSString *s in arrKey) {
        id value = Temp[s];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self getNeedSignStrFrom:value];
        }
        if([str length] !=0) {
            str = [str stringByAppendingString:@"|"];
        }
        str = [str stringByAppendingFormat:@"%@",value];
        
    }
    
//    NSLog(@"Sign keys:%@",[arrKey componentsJoinedByString:@"|"]);
//    NSLog(@"Sign str:%@",str);
    
    pubSign = Temp[@"sign"];
    
//    str = @"96031709061000004015|成功|online-transid|支付宝app支付|20002|100|1";
//    pubSign = @"O2cGhVR/cbnHD+QU/o4ET6jXfw7Tfdxti5uL8CsLNTrje98ntPxd+ygs85x081Rp1U+BJI4ACC7bO3T8BUCktoC4hzVRQk5GWZas/Q/bAh6UcYy6wZeLCJJ0A0z14GNp1TD15tgnLbjtPG6b135gHFLu+/J/CEHLLyLmGrt58n8=";
    
    BOOL isVerify = [RSAFISHER verifyString:str withSign:pubSign publicKey:app_public_key];
    
    NSLog(@"Pub isVerify = %@",isVerify?@"验证成功":@"验证失败");
    
    return isVerify;
    
}

//- (NSString *)decryString:(NSString*)plainText{
//    NSString * decWithPublicKey = [RSA decryptString:plainText publicKey:app_public_key];
//    NSLog(@"app_public_key decResult: %@", decWithPublicKey);
//    
//    return decWithPublicKey;
//}

/**
 responseBody = {
 fmId = 92951709051000003002;
 message = "\U6210\U529f";
 payTransId = "online-transid";
 paymentMethod = "\U652f\U4ed8\U5b9dapp\U652f\U4ed8";
 paymentMethodCode = 20002;
 responseData =     {
 "biz_content" = "app_id=2017060807447672&biz_content=%7B%22body%22%3A%22test%22%2C%22out_trade_no%22%3A%2292951709051000003002%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E9%9D%9E%E7%A0%81%22%2C%22total_amount%22%3A%220.01%22%7D&timestamp=2017-09-05+11%3A22%3A29&charset=utf-8&notify_url=http%3A%2F%2F115.159.117.231%3A8905%2Fnotify&sign_type=RSA&method=alipay.trade.app.pay&version=1.0&sign=F2AJBOqpRIgLZdezp48gzSDI5xBeyvrNbsnGBxcVTc5jhu6cwTjqsIGml%2BUjHQANMH2A6mJsT4fhKYUICn3tMZlBYbXK2TO1b2haxmQSufWzWV4mg6el1YAR%2FqL2t08tbjhJlcJIFUCbZNcTWluH%2F5Yy3LhQ2VGmuAewp7wBWC4%3D";
 };
 sign = "cSz1jrmu5TC/QEmkh3i9+teWX1dU9zSDwbjwUQBt3TsprGWputE1kKSlmWW1BBIFkVZ+HHAu0X5QpiFVUN848zSljn9NyrLZj+NRRHsLeMRHVz/XLiPfkRTra6eixBZ9nyj8RvANP11aY//vDzYXRcwFQdT60R+/xKS7Ksydihg=";
 statusCode = 100;
 ver = 1;
 }
 */


@end
