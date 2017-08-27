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

#define FMNet (NetHelper *)[NetHelper sharedInstance]

typedef void (^SuccessBlock)(id responseBody);
typedef void (^FailureBlock)(NSString *error);

@interface NetHelper : AFHTTPSessionManager <WXApiDelegate>

+ (instancetype)sharedInstance;

/**
 *3.	getVerifyCode	【发送验证码】
 */

- (void)fmCreatPay:(FmPrepayModel*)payModel AndScheme:(NSString*)shchme successBlock:(SuccessBlock )successBlock failureBlock:(FailureBlock)failureBlock;

- (void)initApi:(NSString*)wxAppID;

- (BOOL)handlePayOpen:(NSURL*)url;

@end
