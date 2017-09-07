//
//  FmWxPrepayRes.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"
#import "FmWxPrepayDataRes.h"

@protocol FmWxPrepayDataRes
@end

@interface FmWxPrepayRes : JSONModel

@property(nonatomic,copy)NSString<Optional>*fmId;
@property(nonatomic,copy)NSString<Optional>*message;
@property(nonatomic,copy)NSString<Optional>*payTransId;
@property(nonatomic,copy)NSString<Optional>*paymentMethod;
@property(nonatomic,copy)NSString<Optional>*paymentMethodCode;
@property(nonatomic,copy)NSString<Optional>*sign;
@property(nonatomic,copy)NSString<Optional>*statusCode;
@property(nonatomic,copy)NSString<Optional>*ver;
@property(nonatomic)FmWxPrepayDataRes *responseData;

@end


