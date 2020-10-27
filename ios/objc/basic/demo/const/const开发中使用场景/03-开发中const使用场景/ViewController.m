//
//  ViewController.m
//  03-开发中const使用场景
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    1.修饰全局变量 => 全局只读变量 => 代替宏
    2.修饰方法中参数
 */

#define XMGNameKey @"name"

NSString * const name = @"name";

@interface ViewController ()

@end

@implementation ViewController

- (void)test:(int const *)a
{
    *a = 3;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int a = 0;
    
    [self test:&a];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:name];
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
