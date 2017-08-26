//
//  FmPrepayModel.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"
#import "FmPayProductModel.h"

@protocol FmPayProductModel
@end

@interface FmPrepayModel : JSONModel

@property(nonatomic,assign)int ver;
@property(nonatomic,assign)int partnerId;
@property(nonatomic,copy)NSString<Optional>*storeId;
@property(nonatomic,copy)NSString<Optional>*stationId;
@property(nonatomic,copy)NSString<Optional>*partnerOrderId;
@property(nonatomic,copy)NSString<Optional>*paymentMethodCode;
//@property(nonatomic,copy)NSString<Optional>*transDate;
@property(nonatomic,assign)int transAmount;
@property(nonatomic,assign)int undiscountAmount;
@property(nonatomic,strong)NSArray<Optional,FmPayProductModel>*products;


@end
