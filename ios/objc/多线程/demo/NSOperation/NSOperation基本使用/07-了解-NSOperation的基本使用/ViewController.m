//
//  ViewController.m
//  07-了解-NSOperation的基本使用
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self invocationOpeation];
}

-(void)invocationOpeation
{
    
    //1.创建操作,封装任务
    /*
     第一个参数:目标对象 self
     第二个参数:调用方法的名称
     第三个参数:前面方法需要接受的参数 nil
     */
     NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
     NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
     NSInvocationOperation *op3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download3) object:nil];
    
    //2.启动|执行操作
     [op1 start];
     [op2 start];
     [op3 start];
}

-(void)blockOperation
{
    //1.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
    }];
    
    //追加任务
    //注意:如果一个操作中的任务数量大于1,那么会开子线程并发执行任务
    //注意:不一定是子线程,有可能是主线程
    [op3 addExecutionBlock:^{
        NSLog(@"4---%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"5---%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"6---%@",[NSThread currentThread]);
    }];
    
    //2.启动
    [op1 start];
    [op2 start];
    [op3 start];
}

-(void)download1
{
    NSLog(@"%s----%@",__func__,[NSThread currentThread]);
}

-(void)download2
{
    NSLog(@"%s----%@",__func__,[NSThread currentThread]);
}


-(void)download3
{
    NSLog(@"%s----%@",__func__,[NSThread currentThread]);
}

@end
