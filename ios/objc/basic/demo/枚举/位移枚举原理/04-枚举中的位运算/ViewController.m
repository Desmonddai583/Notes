//
//  ViewController.m
//  04-枚举中的位运算
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController
// 1 << n ,2 ^ n
int a = 1 << 0; // 1
int b = 1 << 1; // 2
int c = 1 << 2; // 4
int d = 1 << 3; // 8

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 只要枚举中有位运算就可以使用并运算|
    // 为什么?
    [_textField addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingChanged];
    
    
    
    [self test:c | b];
}

- (void)test:(int)value
{
    // 解析value,判断下是否包含a,b,c,d
    // &:解析有没有包含a,b,c,d
//    NSLog(@"%d %d %d %d",value & a,value & b,value & c,value & d);
    if (value & a) NSLog(@"包含了a");
    if (value & b) NSLog(@"包含了b");
    if (value & c) NSLog(@"包含了c");
    if (value & d) NSLog(@"包含了d");
    
}

- (void)textBegin
{
    NSLog(@"开始编辑的时候就会调用");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
