//
//  NetHelper.m
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "NetHelper.h"

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
        NSLog(@"%@",error);
        failureBlock([error localizedDescription]);
    } ];
}
/**
 *post
 */
- (void)postPath:(NSString *)path WithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self POST:path parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"responseObject%@",responseObject);
        if ([responseObject[@"code"] intValue]==200) {
            successBlock(responseObject);
        }else
        {
            failureBlock(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@",error);
        failureBlock([error localizedDescription]);
    } ];
}

/**
 *3.	getVerifyCode	【发送验证码】
 */
- (void)getGetVerifyCodeWithParameter:(NSDictionary *)parameter successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock{
    
    [self postPath:@"zhizuobang-wap/user/getVerifyCode" WithParameter:parameter successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSString *error) {
        failureBlock(error);
    }];
}

@end
