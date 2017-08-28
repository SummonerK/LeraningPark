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

    
}
- (IBAction)Pay:(id)sender {
    
    [self setModelWithType:1];
    
}

- (void)setModelWithType:(int)type{
    
    NSString * payTpye;
    NSString * schemeStr;
    
    if (type == 1) {
        payTpye = @"20002";
        schemeStr = @"fmsdk";
    }else if (type == 1) {
        payTpye = @"20001";
        schemeStr = @"fmsdk";
    }else if (type == 1) {
        payTpye = @"20003";
        schemeStr = @"FmUPPaySdk";
    }
    
    model.partnerId = 1443;
    model.transAmount = 1;
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
    
    [FMNet fmCreatPay:model AndScheme:schemeStr AndViewController:self successBlock:^(FmResultRes *result) {
        NSLog(@"%@",result.toDictionary);
    } failureBlock:^(FmResultRes *error) {
        NSLog(@"%@",error.toDictionary);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
