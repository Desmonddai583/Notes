//
//  ViewController.m
//  01-加法计算器
//
//  Created by xiaomage on 15/12/26.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *num1TextField;
@property (weak, nonatomic) IBOutlet UITextField *num2TextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sum {
    // 1. 拿到两个字符串
    NSString *sum1String = self.num1TextField.text;
    NSString *sum2String = self.num2TextField.text;
    
    // 判断
    if (sum1String.length == 0) {
        /*
        // 创建对象
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入有误" message:@"请输入第一个数" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        // 显示
        [alertView show];
        */
        [self showInfo:@"请输入第一个数"];
        return;
    }
    
    if (sum2String.length == 0) {
        /*
        // 创建对象
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入有误" message:@"请输入第二个数" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        // 显示
        [alertView show];
        */
        [self showInfo:@"请输入第二个数"];
        return;
    }

    // 2. 把字符串转成数值
    NSInteger sum1 = [sum1String integerValue];
    NSInteger sum2 = [sum2String integerValue];
    
    // 3. 相加
    NSInteger result = sum1 + sum2;
    
    // 4. 显示结果
    self.resultLabel.text = [NSString stringWithFormat:@"%zd", result];
}

- (void)showInfo: (NSString *)info{
    // 创建对象
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入有误" message:info delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    
    // 显示
    [alertView show];
}

@end
