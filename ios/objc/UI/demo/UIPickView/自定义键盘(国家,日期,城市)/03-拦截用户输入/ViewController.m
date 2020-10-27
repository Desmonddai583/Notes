//
//  ViewController.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "FlagTextF.h"
#import "UITextField+test.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *countryTextF;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextF;
@property (weak, nonatomic) IBOutlet UITextField *cityTextF;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryTextF.delegate = self;
    self.birthDayTextF.delegate = self;
    self.cityTextF.delegate = self;
}


//是否允许开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

//开始编辑时调用(成为第一响应者)
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //让当前编辑的文本选中第一个.
    //在运行时,会去找它真实类型的方法.
    [textField initWithText];
    NSLog(@"%s",__func__);
}

//是否允许结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

//当结束编辑时调用
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__func__);
}

//是否允许改变文本框内容(拦截用户输入)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
