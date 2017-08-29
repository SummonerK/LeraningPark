//
//  FmPayProductModel.h
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "JSONModel.h"

@interface FmPayProductModel : JSONModel


@property(nonatomic,copy)NSString<Optional>*pid;
@property(nonatomic,copy)NSString<Optional>*name;
@property(nonatomic,assign)int consumeNum;
@property(nonatomic,assign)int price;
@property(nonatomic,copy)NSString<Optional>*salesType;


@end
