//
//  ViewController.m
//  01-const与宏的区别
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

// 常用字符串,常见基本变量 定义宏

// const
// 苹果一直推荐我们使用const,而不是宏

/*
    const与宏的区别(面试题)
    1.编译时刻 宏:预编译 const:编译
    2.编译检查 宏没有编译检查,const有编译检查
    3.宏的好处 定义函数.方法, const不可以 
    4.宏的坏处 大量使用宏,会导致预编译时间过长
 
    blog:大量使用宏,会导致内存暴增
 
 
 */

#define XMGUserDefaults [NSUserDefaults standardUserDefaults]
#define XMGNameKey @"name"

CGFloat const a = 3;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *str = XMGNameKey;
//    NSString *str2 = XMGNameKey;
//    NSString *str3 = XMGNameKey;
    
//    NSLog(@"%p %p %p",str,str2, str3);
    
    
    [XMGUserDefaults setObject:@"aaa" forKey:XMGNameKey];
    
    [XMGUserDefaults objectForKey:XMGNameKey];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
