//
//  FmPrepayModel.m
//  FmOnlinePayApi
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "FmPrepayModel.h"

@implementation FmPrepayModel

-(id)init
{
    self = [super init];
    if (self) {
        //do initial class setup
        self.ver = 1;
        self.storeId = @"-1";
        self.stationId = @"-1";
        self.undiscountAmount = 0;
    }
    return self;
}

@end
