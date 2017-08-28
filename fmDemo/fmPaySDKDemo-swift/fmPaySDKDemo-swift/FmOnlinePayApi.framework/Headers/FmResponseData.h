//
//  FmResponseData.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/28.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"

@interface FmResponseData : JSONModel

@property(nonatomic,copy)NSString<Optional>*timestamp;///<交易完成时间
@property(nonatomic,copy)NSString<Optional>*totalAmount;///<交易金额
@property(nonatomic,copy)NSString<Optional>*tradeNo;///<支付宝交易序号
@property(nonatomic,copy)NSString<Optional>*sellerId;///<售卖id
@property(nonatomic,copy)NSString<Optional>*outTradeNo;///<非码交易号
@property(nonatomic,copy)NSString<Optional>*fmId;///<非码订单号

@end
