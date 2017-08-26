//
//  ViewController.m
//  testDemo-OC
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "ViewController.h"
#import <FmOnlinePayApi/FmOnlinePayApi.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FmPrepayModel * model = [FmPrepayModel new];

    NSLog(@"model%@",model);
    
//    [FMNet getGetVerifyCodeWithParameter:@{@"key":@"value"} successBlock:^(id responseBody) {
//        ;
//    } failureBlock:^(NSString *error) {
//        ;
//    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
