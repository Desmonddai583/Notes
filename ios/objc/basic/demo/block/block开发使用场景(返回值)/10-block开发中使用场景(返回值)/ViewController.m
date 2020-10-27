//
//  ViewController.m
//  10-block开发中使用场景(返回值)
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorManager.h"

@interface ViewController ()

@end

@implementation ViewController
/*
    链式编程思想:把所有的语句用.号连接起来,好处:可读性非常好
 */

/*
    需求:封装一个计算器,提供一个加号方法
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CalculatorManager *mgr = [[CalculatorManager alloc] init];
    // + 5
    // mgr.add(5).add(5).add(5).add(5).add(5).add(5)
    // mgr.add(5)
//    [[[[[mgr add:5] add:5] add:5] add:6] add:7];
   
    mgr.add(5).add(5).add(5).add(5);
    
    NSLog(@"%d",mgr.result);
//    [mgr add:5];
//    [mgr add:5];
//    [mgr add:5];
//    [mgr add:5];
    
    
//    make.center;
//     make.center.equalTo(ws.view);
//    self.test();
//    void(^block)() = ^{
//        NSLog(@"调用了block");
//    };
    self.test();
}

- (void(^)())test
{
//    NSLog(@"%s",__func__);
//    void(^block)() = ^{
//        
//    };
    return ^{
        NSLog(@"调用了block");
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
