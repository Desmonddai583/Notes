//
//  ViewController.m
//  03-掌握-NSThread基本使用
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//


#import "ViewController.h"
#import "XMGThread.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self createNewThread1];
}

//1.alloc init 创建线程,需要手动启动线程
//线程的生命周期:当任务执行完毕之后被释放掉
-(void)createNewThread1
{
    //1.创建线程
    /*
     第一个参数:目标对象  self
     第二个参数:方法选择器 调用的方法
     第三个参数:前面调用方法需要传递的参数 nil
     */
    XMGThread *threadA = [[XMGThread alloc]initWithTarget:self selector:@selector(run:) object:@"ABC"];
    
    //设置属性
    threadA.name = @"线程A";
    //设置优先级  取值范围 0.0 ~ 1.0 之间 最高是1.0 默认优先级是0.5
    threadA.threadPriority = 1.0;
    
    //2.启动线程
    [threadA start];

    
//    NSThread *threadB = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"ABC"];
//    threadB.name = @"线程b";
//    threadB.threadPriority = 0.1;
//    [threadB start];
//    
//    NSThread *threadC = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"ABC"];
//    threadC.name = @"线程C";
//    [threadC start];
}

//2.分离子线程,自动启动线程
-(void)createNewThread2
{
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"分离子线程"];
}

//3.开启一条后台线程
-(void)createNewThread3
{
    [self performSelectorInBackground:@selector(run:) withObject:@"开启后台线程"];
}

-(void)run:(NSString *)param
{
//    NSLog(@"---run----%@---%@",[NSThread currentThread].name,param);
    for (NSInteger i = 0; i<10000; i++) {
        NSLog(@"%zd----%@",i,[NSThread currentThread].name);
    }
}

@end
