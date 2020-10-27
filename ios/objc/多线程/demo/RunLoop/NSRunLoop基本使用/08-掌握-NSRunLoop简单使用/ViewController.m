//
//  ViewController.m
//  08-掌握-NSRunLoop简单使用
//
//  Created by xiaomage on 16/2/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.获得主线程对应的runloop
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    
    //2.获得当前线程对应的runLoop
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    
    NSLog(@"%p---%p",mainRunLoop,currentRunLoop);
//    NSLog(@"%@",mainRunLoop);
    
    //Core
    NSLog(@"%p",CFRunLoopGetMain());
    NSLog(@"%p",CFRunLoopGetCurrent());
    
    NSLog(@"%p",mainRunLoop.getCFRunLoop);
    
    //Runloop和线程的关系
    //一一对应,主线程的runloop已经创建,但是子线程的需要手动创建
    [[[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil] start];
}

//在runloop中有多个运行模式,但是runloop只能选择一种模式运行
//mode里面至少要有一个timer或者是source
-(void)run
{
    //如何创建子线程对应的runLoop,currentRunLoop懒加载的
    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    NSLog(@"run---%@",[NSThread currentThread]);
}

@end
