//
//  FmWxPrepayDataRes.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/27.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"

@interface FmWxPrepayDataRes : JSONModel

@property(nonatomic,copy)NSString<Optional>*appid;
@property(nonatomic,copy)NSString<Optional>*partnerid;
@property(nonatomic,copy)NSString<Optional>*prepayid;
@property(nonatomic,copy)NSString<Optional>*package;
@property(nonatomic,copy)NSString<Optional>*noncestr;
@property(nonatomic,copy)NSString<Optional>*timestamp;
@property(nonatomic,copy)NSString<Optional>*biz_content;
@property(nonatomic,copy)NSString<Optional>*tn;

@end
