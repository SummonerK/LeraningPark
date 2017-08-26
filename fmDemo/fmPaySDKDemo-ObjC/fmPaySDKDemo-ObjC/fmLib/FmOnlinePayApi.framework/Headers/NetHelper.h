//
//  NetHelper.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define FMNet (NetHelper *)[NetHelper sharedInstance]
static NSString * const HOSTPath   = @"http://tpam.truekey.mobi/";
static NSInteger const TIMEOUT  = 30;
static NSInteger const TIMEOUTQUSTION  = 20;

typedef void (^SuccessBlock)(id responseBody);
typedef void (^FailureBlock)(NSString *error);

@interface NetHelper : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)getPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock;

- (void)postPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *3.	getVerifyCode	【发送验证码】
 */
- (void)getGetVerifyCodeWithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock;

@end
