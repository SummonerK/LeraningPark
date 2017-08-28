//
//  FmResultRes.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/28.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"
#import "FmResponseData.h"
#import "FMCodeManager.h"

@protocol FmResponseData
@end

@interface FmResultRes : JSONModel
@property(nonatomic,assign)FMRESULTCODE resultCode;///<回调码
@property(nonatomic,copy)NSString<Optional>*resultMsg;///<提示信息
@property(nonatomic)FmResponseData *responseData;///<支付宝返回的交易信息 微信没有

@end
