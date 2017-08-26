//
//  ViewController.m
//  fmPaySDKDemo-ObjC
//
//  Created by Luofei on 2017/8/25.
//  Copyright © 2017年 fmPay. All rights reserved.
//

#import "ViewController.h"
#import <FmOnlinePayApi/FmOnlinePayApi.h>

@interface ViewController ()<UITextFieldDelegate>{
    __weak IBOutlet UITextField *tf_amount;
    int trueAmount;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trueAmount = 0;
    
    FmPrepayModel * model = [FmPrepayModel new];
    
    NSLog(@"model = %@",model);
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

- (void)tapAction:(UIGestureRecognizer*)gesture
{
    printf("tap");
    [tf_amount resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    tf_amount.text = @"";
    return YES;
}
    
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * str = textField.text;
    
    if (str.intValue == 0) {
        textField.text = @"";
    }
    return YES;
}
    
- (void)textFieldDidEndEditing:(UITextField *)textField{
    double amount = tf_amount.text.doubleValue;
    trueAmount = tf_amount.text.intValue;
    
    tf_amount.text = [self getAmountStringWithNumber:amount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)action_setAmount:(id)sender {
    [tf_amount resignFirstResponder];
}


#pragma mark-支付操作演示
#pragma mark 支付宝支付
- (IBAction)action_aliPay:(id)sender {
    
    
}


#pragma mark 微信支付
- (IBAction)action_wxPay:(id)sender {
    
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
