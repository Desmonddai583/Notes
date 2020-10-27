//
//  ViewController.m
//  08-Block变量传递
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    __block int a = 3;
    
    // 如果是局部变量,Block是值传递
    
    // 如果是静态变量,全局变量,__block修饰的变量,block都是指针传递
    
    void(^block)() = ^{
        
        NSLog(@"%d",a);
        
    };
    
    a = 5;
    
    block();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
