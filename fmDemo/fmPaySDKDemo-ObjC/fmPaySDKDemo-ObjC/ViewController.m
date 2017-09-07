//
//  ViewController.m
//  fmPaySDKDemo-ObjC
//
//  Created by FMSDK on 2017/8/25.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "ViewController.h"
#import <FmOnlinePayApi/FmOnlinePayApi.h>

@interface ViewController ()<UITextFieldDelegate>{
    __weak IBOutlet UITextField *tf_amount;
    
    __weak IBOutlet UITextField *tf_storeId;
    
    __weak IBOutlet UITextView *tv_content;
    
    int trueAmount;//真实金额, Int 数据类型, 单位（分）
    
    FmPrepayModel * model; //商品Model
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trueAmount = 1;
    
    model = [FmPrepayModel new];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    tf_amount.text = [NSString stringWithFormat:@"%d",trueAmount];
    tf_storeId.text = @"-1";
}

- (void)tapAction:(UIGestureRecognizer*)gesture
{
    printf("tap");
    [tf_amount resignFirstResponder];
    [tf_storeId resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = @"";
    return YES;
}
    
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"string = %@",string);
    
    if ( textField == tf_amount && tf_amount.text.intValue == 0) {
        textField.text = @"";
    }
    return YES;
}
    
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if ([tf_storeId.text isEqualToString:@""]) {
        tf_storeId.text = @"-1";
    }
    
    if (textField == tf_amount) {
        trueAmount = tf_amount.text.intValue;
    }
    
//    double amount = tf_amount.text.doubleValue;
//    tf_amount.text = [self getAmountStringWithNumber:amount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)action_setAmount:(id)sender {
    [tf_amount resignFirstResponder];
    [tf_storeId resignFirstResponder];
}


#pragma mark-支付操作演示
//支付宝支付
- (IBAction)action_aliPay:(id)sender {
    [self setModelWithType:1];
    
}

//微信支付
- (IBAction)action_wxPay:(id)sender {
    [self setModelWithType:2];
}

//银联支付
- (IBAction)action_unPay:(id)sender {
    [self setModelWithType:3];
}


- (void)setModelWithType:(int)type{
    [tf_amount resignFirstResponder];
    [tf_storeId resignFirstResponder];
    
    if (trueAmount == 0) {
        tv_content.text = @"请设置支付金额";
        return;
    }
    
    NSString * payTpye;
    NSString * schemeStr;
    model.partnerId = 1443;
    
    if (type == 1) {
        payTpye = @"20002";
        schemeStr = @"fmpaysdkal";
        model.partnerId = 1447;
    }else if (type == 2) {
        payTpye = @"20001";
    }else if (type == 3) {
        payTpye = @"20003";
        schemeStr = @"FmUPPaySdk";
    }
    
    NSLog(@"%@ %@",payTpye,schemeStr);
    
    model.storeId = tf_storeId.text;
    model.transAmount = trueAmount;
    model.paymentMethodCode = payTpye;
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
    
    [FMNet fmCreatPay:model AndScheme:schemeStr AndMode:@"01" AndViewController:self successBlock:^(FmResultRes *result) {
        NSLog(@"%@",result.toDictionary);
        tv_content.text = result.toJSONString;
    } failureBlock:^(FmResultRes *error) {
         NSLog(@"%@",error.toDictionary);
        tv_content.text = error.toJSONString;
    }];
    
    
}



#pragma mark -other extend
- (NSString *)getAmountStringWithNumber:(double)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money/100]];
    return formattedNumberString;
}





@end
