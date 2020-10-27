//
//  ViewController.m
//  03-掌握-Runloop应用
//
//  Created by xiaomage on 16/2/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** 注释 */
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ViewController

- (IBAction)createBtnClick:(id)sender {
    
    //1.创建线程
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(task1) object:nil];
    
    [self.thread start];
    
}
- (IBAction)otherBtnClick:(id)sender {
    
    //[self.thread start];
    
    [self performSelector:@selector(task2) onThread:self.thread withObject:nil waitUntilDone:YES];
}

-(void)task1
{
    NSLog(@"task1---%@",[NSThread currentThread]);
//    while (1) {
//       NSLog(@"task1---%@",[NSThread currentThread]);
//    }
    //解决方法:开runloop
    //1.获得子线程对应的runloop
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    //保证runloop不退出
    //NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    //[runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    //2.默认是没有开启
    [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    NSLog(@"---end----");
}

-(void)task2
{
    NSLog(@"task2---%@",[NSThread currentThread]);
}

-(void)run
{
    NSLog(@"%s",__func__);
}

//Runloop中自动释放池的创建和释放
//第一次创建:启动runloop
//最后一次销毁:runloop退出的时候
//其他时候的创建和销毁:当runloop即将睡眠的时候销毁之前的释放池,重新创建一个新的
@end
