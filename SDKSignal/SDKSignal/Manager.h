//
//  Manager.h
//  SDKSignal
//
//  Created by Luofei on 2018/5/21.
//  Copyright © 2018年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SManager (Manager *)[Manager sharedInstance]


@interface Manager : NSObject

+ (instancetype)sharedInstance;

- (void)HelloAPI;

@end
