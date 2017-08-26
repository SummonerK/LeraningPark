//
//  FmPayProductModel.m
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "FmPayProductModel.h"

@implementation FmPayProductModel

-(id)init
{
    self = [super init];
    if (self) {
        //do initial class setup
        self.salesType = @"NORMAL";
    }
    return self;
}

@end
