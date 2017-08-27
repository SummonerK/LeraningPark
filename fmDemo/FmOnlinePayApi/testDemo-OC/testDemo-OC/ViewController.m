//
//  ViewController.m
//  testDemo-OC
//
//  Created by Luofei on 2017/8/26.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "ViewController.h"
#import <FmOnlinePayApi/FmOnlinePayApi.h>

@interface ViewController (){
    FmPrepayModel * model;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [FmPrepayModel new];

    
    
//    [FMNet getGetVerifyCodeWithParameter:@{@"key":@"value"} successBlock:^(id responseBody) {
//        ;
//    } failureBlock:^(NSString *error) {
//        ;
//    }];
    
}
- (IBAction)Pay:(id)sender {
    
    [self setModelWithType:1];
    
}

- (void)setModelWithType:(int)type{
    
    model.partnerId = 1447;
    model.transAmount = 1;
    model.paymentMethodCode = type == 1 ? @"20002" : @"20001";
    model.partnerOrderId = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
    NSMutableArray * products = [NSMutableArray new];
    
    for (int i = 1; i<2; i++) {
        FmPayProductModel * product = [FmPayProductModel new];
        product.pid = [NSString stringWithFormat:@"%d",i];
        product.price = 1;
        product.name = [NSString stringWithFormat:@"商品%d",i];
        product.consumeNum = 1;
        [products addObject:product];
    }
    model.products = products;
    
    [FMNet fmCreatPay:model successBlock:^(id responseBody) {
        NSLog(@"result = %@",responseBody);
    } failureBlock:^(NSString *error) {
        NSLog(@"error = %@",error);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
