//
//  ViewController.m
//  09-Block开发使用场景(参数使用)
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "CacultorManager.h"

// 怎么区分参数是block,就看有没有^,只要有^.把block当做参数
// 把block当做参数,并不是马上就调用Block,什么时候调用,由方法内部决定
// 什么时候需要把block当做参数去使用:做的事情由外界决定,但是什么时候做由内部决定.

/*
    需求:封装一个计算器,提供一个计算方法,怎么计算由外界决定,什么时候计算由内部决定.
 
 */


@interface ViewController ()

@end

@implementation ViewController
- (void)test:(int)a
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test:3];
    
    // 创建计算器管理者
    CacultorManager *mgr = [[CacultorManager alloc] init];
    [mgr cacultor:^(NSInteger result){
        result += 5;
        result += 6;
        result *= 2;
        return result;
    }];
    
    NSLog(@"%ld",mgr.result);
    
    
//    [UIView animateWithDuration:0 animations:^{
//        
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
