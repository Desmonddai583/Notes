//
//  ViewController.m
//  09-掌握-GCD常用函数
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGPerson.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self once];
    
    XMGPerson *p1 = [[XMGPerson alloc]init];
    XMGPerson *p2 = [[XMGPerson alloc]init];
    NSLog(@"%@---%@",p1.books,p2.books);
}

//延迟执行
-(void)delay
{
    NSLog(@"start-----");
    
    //1. 延迟执行的第一种方法
    //[self performSelector:@selector(task) withObject:nil afterDelay:2.0];
    
    //2.延迟执行的第二种方法
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:YES];
    
    //3.GCD
//    dispatch_queue_t queue = dispatch_get_main_queue();
     dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    /*
     第一个参数:DISPATCH_TIME_NOW 从现在开始计算时间
     第二个参数:延迟的时间 2.0 GCD时间单位:纳秒
     第三个参数:队列
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"GCD----%@",[NSThread currentThread]);
    });

}

//一次性代码
//不能放在懒加载中的,应用场景:单例模式
-(void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"---once----");
    });
}

-(void)task
{
    NSLog(@"task----%@",[NSThread currentThread]);
}
@end
