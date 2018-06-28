//
//  Manager.m
//  SDKSignal
//
//  Created by Luofei on 2018/5/21.
//  Copyright © 2018年 lf. All rights reserved.
//

#import "Manager.h"

@implementation Manager

+ (instancetype)sharedInstance {
    static Manager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:onceToken];
        }
    });
    return _sharedInstance;
}

- (void)HelloAPI{
    NSLog(@"Hello ,this is SOLManager zone !");
}

@end
