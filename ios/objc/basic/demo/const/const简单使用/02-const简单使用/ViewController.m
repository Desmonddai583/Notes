//
//  ViewController.m
//  02-const简单使用
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    const作用:  1.修饰右边基本变量或者指针变量 int a int *p
               2.被const修饰变量只读
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修饰基本变量
    //int const a = 3;
    // const int a = 3;
    // a = 5;
    
    // 修饰指针变量
//    int a = 3;
//    int b ;
//    int  * const p = &a;
//     a = 5;
//    *p = 8;
//    p = &b;
    
    // 面试题
    int * const p;  // p:只读  *p:变量
    int const * p1; // p1:变量 *p1:只读
    const int * p2; // p2:变量 *p2:只读
    const int * const p3; // p3:只读 *p3:只读
    int const * const p4; // p4:只读 *p4:只读
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
