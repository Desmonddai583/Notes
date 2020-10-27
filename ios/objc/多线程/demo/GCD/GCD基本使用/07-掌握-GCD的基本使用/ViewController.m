//
//  ViewController.m
//  07-掌握-GCD的基本使用
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ----------------------
#pragma Events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    [self asyncConcurrent];
}

#pragma mark ----------------------
#pragma Methods
//异步函数+并发队列:会开启多条线程,队列中的任务是并发执行
-(void)asyncConcurrent
{
    //1.创建队列
    /*
     第一个参数:C语言的字符串,标签
     第二个参数:队列的类型
        DISPATCH_QUEUE_CONCURRENT:并发
        DISPATCH_QUEUE_SERIAL:串行
     */
    //dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    
    //获得全局并发队列
    /*
     第一个参数:优先级
     第二个参数:
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"---satrt----");
    
    //2.1>封装任务2>添加任务到队列中
    /*
     第一个参数:队列
     第二个参数:要执行的任务
     */
    dispatch_async(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
    
     NSLog(@"---end----");
}

//异步函数+串行队列:会开线程,开一条线程,队列中的任务是串行执行的
-(void)asyncSerial
{
    //1.创建队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);

    //2.封装操作
    dispatch_async(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
}

//同步函数+并发队列:不会开线程,任务是串行执行的
-(void)syncConcurrent
{
    //1.创建队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"---start---");
    //2.封装任务
    dispatch_sync(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
    
     NSLog(@"---end---");
}

//同步函数+串行队列:不会开线程,任务是串行执行的
-(void)syncSerial
{
    //1.创建队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_SERIAL);
    
    //2.封装任务
    dispatch_sync(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
}

//异步函数+主队列:所有任务都在主线程中执行,不会开线程
-(void)asyncMain
{
    //1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();

    //2.异步函数
    dispatch_async(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
}

//同步函数+主队列:死锁
//注意:如果该方法在子线程中执行,那么所有的任务在主线程中执行,
-(void)syncMain
{
    //1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"start----");
    //2.同步函数
    //同步函数:立刻马上执行,如果我没有执行完毕,那么后面的也别想执行
    //异步函数:如果我没有执行完毕,那么后面的也可以执行
    dispatch_sync(queue, ^{
        NSLog(@"download1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"download3----%@",[NSThread currentThread]);
    });
    
    NSLog(@"end---");
}
@end
