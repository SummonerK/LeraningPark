//
//  NetHelper.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "FmPrepayModel.h"
#import "WXApi.h"
#import "FmResultRes.h"

#define FMNet (NetHelper *)[NetHelper sharedInstance]

typedef void (^SuccessBlock)(FmResultRes * result);
typedef void (^FailureBlock)(FmResultRes * error);

@interface NetHelper : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/**
 * 调起fmPay
 @param payModel        商品的数据
 @param shchme          url shchme
 @param mode            支付mode 银联支付使用 "01": 测试支付状态 "00":真实支付状态
 @param ViewC           支付代理页
 @return successBlock   成功返回 failureBlock   失败返回
 */
- (void)fmCreatPay:(FmPrepayModel*)payModel AndScheme:(NSString*)shchme AndMode:(NSString*)mode AndViewController:(UIViewController*)ViewC successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock;

/**
 * 微信支付需要注册appID
 */
- (void)initApi:(NSString*)wxAppID;
/**
 * fmPay回调设置
 */
- (BOOL)handlePayOpen:(NSURL*)url;

@end
